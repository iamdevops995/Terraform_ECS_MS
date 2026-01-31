module "vpc" {
  source = "./modules/vpc"
  ecs-vpc-cidr=var.ecs-vpc-cidr
  ecs-pub-sub-1-cidr_block=var.ecs-pub-sub-1-cidr_block
  ecs-pub-sub-2-cidr_block=var.ecs-pub-sub-2-cidr_block
  ecs-pri-sub-1-cidr_block=var.ecs-pri-sub-1-cidr_block
  ecs-pri-sub-2-cidr_block=var.ecs-pri-sub-2-cidr_block
  az=var.az
}

module "ecs" {
  source = "./modules/ecs"
  docker_hub_credentials_arn = module.secret-manager.docker_hub_credentials_arn
  execution_role_arn = module.iam.role_arn
  ecs_cluster_name = "ecs-cluster"
  service_name = "hello-service"
  public_subnet_ids = module.vpc.public_subnet_ids
  ecs-sg-id = module.vpc.ecs-sg-id
}
module "iam" {
  source = "./modules/iam"
}
module "secret-manager" {
  source = "./modules/secret-manager"
}



# --- IGNORE ---
# resource "aws_route_table_association" "ecs-rt2"
