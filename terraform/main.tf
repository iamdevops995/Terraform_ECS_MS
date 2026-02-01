module "vpc" {
  source                   = "./modules/vpc"
  ecs-vpc-cidr             = var.ecs-vpc-cidr
  ecs-pub-sub-1-cidr_block = var.ecs-pub-sub-1-cidr_block
  ecs-pub-sub-2-cidr_block = var.ecs-pub-sub-2-cidr_block
  ecs-pri-sub-1-cidr_block = var.ecs-pri-sub-1-cidr_block
  ecs-pri-sub-2-cidr_block = var.ecs-pri-sub-2-cidr_block
  az                       = var.az
}

module "ecs" {
  source                     = "./modules/ecs"
  docker_hub_credentials_arn = module.secret-manager.secret_arn
  # execution_role_arn         = module.iam.role_arn
  ecs_cluster_name           = "ecs-cluster"
  service_name               = "hello-service"
  public_subnet_ids          = module.vpc.public_subnet_ids
  ecs-sg-id                  = module.vpc.ecs-sg-id
  # depends_on = [module.iam]
}
# module "iam" {
#   source = "./modules/iam"
# }
module "secret-manager" {
  source           = "./modules/secretManager"
  username         = var.docker_hub_username
  password         = var.docker_hub_password
  ecs_cluster_name = module.ecs.ecs_cluster_name
}

