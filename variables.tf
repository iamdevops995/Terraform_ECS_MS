variable "region" {}
# variable "bucket" {}
variable "ecs-vpc-cidr" {}
variable "ecs-pub-sub-1-cidr_block" {}
variable "ecs-pub-sub-2-cidr_block" {}
variable "ecs-pri-sub-1-cidr_block" {}
variable "ecs-pri-sub-2-cidr_block" {}
variable "az" {}
# variable "docker_hub_credentials_arn" {}

# variable "public_subnet_ids" {  
#   description = "List of public subnet IDs"
#   type        = list(string)
# }
# variable "vpc_id" {
# }

# variable "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   type        = list(string)
# }
# variable "ecs-sg-id" {
# }
# variable "execution_role_arn" {}
# variable "ecs_cluster_name" {}
variable "docker_hub_username" {}
variable "docker_hub_password" {}