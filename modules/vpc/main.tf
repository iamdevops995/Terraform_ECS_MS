# VPC
resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.ecs-vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ecs-vpc"
  }
}

# Public Subnets (2 AZs)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = cidrsubnet(var.ecs-vpc-cidr, 8, count.index) # 10.0.0.0/24, 10.0.1.0/24
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-public-${count.index}"
  }
}

# Private Subnets (2 AZs)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = cidrsubnet(var.ecs-vpc-cidr, 8, count.index + 10) # 10.0.10.0/24, 10.0.11.0/24
  availability_zone = var.az[count.index]

  tags = {
    Name = "ecs-private-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ecs_vpc_igw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs-igw"
  }
}

# NAT Gateway + EIP
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ecs_nat_gateway" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "ecs-nat-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_vpc_igw.id
  }

  tags = {
    Name = "ecs-public-rtb"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

# Private Route Table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs-private-rtb"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ecs_nat_gateway.id
}

# Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}