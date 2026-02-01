variable "ecs_cluster_name" {}
variable "username" {
  description = "Docker Hub username"
  type        = string
}

variable "password" {
  description = "Docker Hub password"
  type        = string
  sensitive   = true
}
