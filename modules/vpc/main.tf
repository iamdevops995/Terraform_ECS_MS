resource "aws_vpc" "ecs-vpc" {
  cidr_block           = var.ecs-vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}
resource "aws_subnet" "public" {
    count=2
    vpc_id = aws_vpc.ecs-vpc.id
    cidr_block = var.ecs-pub-sub-1-cidr_block
    map_public_ip_on_launch = true
    availability_zone = var.az[count.index]
}
locals {
  cidr_block = var.ecs-pri-sub-1-cidr_block
}

# resource "aws_subnet" "ecs-pub-sub-2" {
#     vpc_id = aws_vpc.ecs-vpc.id
#     cidr_block = var.ecs-pub-sub-2-cidr_block
#     map_public_ip_on_launch = true
#     availability_zone = "us-east-1b"
# }
#pri
resource "aws_subnet" "private" {
    count = 2
    vpc_id = aws_vpc.ecs-vpc.id
    cidr_block = local.cidr_block
    availability_zone = var.az[count.index]
}

# resource "aws_subnet" "ecs-pri-sub-2" {
#     vpc_id = aws_vpc.ecs-vpc.id
#     cidr_block = var.ecs-pri-sub-2-cidr_block
#     availability_zone = "us-east-1b"
# }
resource "aws_internet_gateway" "ecs-vpc-igw" {
    vpc_id = aws_vpc.ecs-vpc.id
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "ecs-aws_nat_gateway" {
    subnet_id = aws_subnet.public[0].id
    allocation_id = aws_eip.nat-eip.id
  tags = {
    Name = "ecs-aws_nat_gateway"
}
}

# resource "aws_route_table" "ecs-rt1" {
#     vpc_id = aws_vpc.ecs-vpc.id
#     route {
#         gateway_id = aws_internet_gateway.ecs-vpc-igw.id
#         nat_gateway_id = aws_nat_gateway.ecs-aws_nat_gateway.id
#     }
#   tags = {
#     Name = "ecs-rt1"
# }   
# }

# resource "aws_route_table_association" "ecs-rt1-ass" {
#   route_table_id = aws_route_table.ecs-rt1.id
#   subnet_id = aws_subnet.ecs-pub-sub-1.id
# }


resource "aws_route_table" "public-rtb" {
    vpc_id = aws_vpc.ecs-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ecs-vpc-igw.id
    }

    tags = {
        Name = "public-rtb"
    }
}

resource "aws_route_table_association" "public-rt" {
  count =2
  route_table_id = aws_route_table.public-rtb.id
  subnet_id = aws_subnet.public[count.index].id
}
# resource "aws_route_table_association" "public-rt2-ass" {
#   route_table_id = aws_route_table.public-rtb.id
#   subnet_id = aws_subnet.ecs-pub-sub-2.id
# }

resource "aws_route_table" "private-rtb" {
    vpc_id = aws_vpc.ecs-vpc.id


    tags = {
            Name = "private-rtb"
        }
}

resource "aws_route_table_association" "private-1" {  
  count=2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rtb.id
}

# resource "aws_route_table_association" "private-2" {  
#   subnet_id      = aws_subnet.ecs-pri-sub-2.id
#   route_table_id = aws_route_table.private-rtb.id
# }

resource "aws_route" "private_nat_route-1" {
  route_table_id         = aws_route_table.private-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ecs-aws_nat_gateway.id
}


resource "aws_security_group" "ecs-sg" {
  name        = "ecs-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.ecs-vpc.id

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
}