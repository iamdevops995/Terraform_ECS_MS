module "vpc" {
  source = "./vpc"
  ecs-vpc-cidr=var.ecs-vpc-cidr
  ecs-pub-sub-1-cidr_block=var.ecs-pub-sub-1-cidr_block
  ecs-pub-sub-2-cidr_block=var.ecs-pub-sub-2-cidr_block
  ecs-pri-sub-1-cidr_block=var.ecs-pri-sub-1-cidr_block
  ecs-pri-sub-2-cidr_block=var.ecs-pri-sub-2-cidr_block
  az=var.az
}