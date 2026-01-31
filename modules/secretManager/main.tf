resource "aws_secretsmanager_secret" "docker_Secret" {
  name = "${var.ecs_cluster_name}-docker_sercret"
}

resource "aws_secretsmanager_secret_version" "ecs_docker_secret" {
  secret_id     = aws_secretsmanager_secret.docker_Secret.id
  secret_string = jsonencode({
    username = var.username
    password= var.password
  })
}