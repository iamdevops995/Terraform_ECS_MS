terraform {
  backend "s3" {
    bucket       = "ecs-microservice-store"
    key          = "bucket/ecs-microservice-store.tfstate"
    region       = "us-east-1"
    use_lockfile = true

  }
}