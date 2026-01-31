resource "aws_iam_role" "ecstaskexecution_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ecsTaskExecutionRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecstaskexecution_role.name
  policy_arn = [ "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" , "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess" ]
}

