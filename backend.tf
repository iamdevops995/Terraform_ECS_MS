terraform {
  backend "s3" {
    bucket = var.bucket
    key = "bucket/ecs-microservice-store.tfstate"
    region = var.region
    use_lockfile = true
    
  }
}