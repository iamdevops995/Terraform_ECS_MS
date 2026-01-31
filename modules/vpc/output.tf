output "vpc_id" {
  value = aws_vpc.ecs-vpc.id
}
output "igw-id" {
  value = aws_internet_gateway.ecs-vpc-igw.id
}
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "ecs-sg-id" {
  value = aws_security_group.ecs-sg.id
}