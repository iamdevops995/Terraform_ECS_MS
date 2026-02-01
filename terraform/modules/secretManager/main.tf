resource "aws_secretsmanager_secret" "ecs_docker_Secret" {
  name = "${var.ecs_cluster_name}-docker_sercret-1"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ecs_docker_secret-1" {
  secret_id     = aws_secretsmanager_secret.ecs_docker_Secret.id
  secret_string = jsonencode({
    username = var.username
    password= var.password
  })
}