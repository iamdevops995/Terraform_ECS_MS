output "secret_arn" {
  value = aws_secretsmanager_secret_version.ecs_docker_secret.arn
}