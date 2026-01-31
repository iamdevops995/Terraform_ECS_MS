output "vpc_id" {
  value = aws_vpc.ecs-vpc.id
}
output "igw-id" {
  value = aws_internet_gateway.ecs-vpc-igw.id
}
output "private-ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}