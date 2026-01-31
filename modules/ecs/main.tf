resource "aws_ecs_cluster" "ecs_ms_cluster" {
  name = var.ecs_cluster_name
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
}


resource "aws_ecs_task_definition" "helloservice-task" {
  family = "${var.ecs_cluster_name}-task"
  requires_compatibilities = [ "FARGATE" ]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn = "arn:aws:iam::211125578268:role/ecsTaskExecutionRole"

  
  container_definitions = jsonencode([
    {
      name      = "helloservice"
      image     = "iamdevops995/helloservice:v1"
      cpu       = 10
      memory    = 256
      essential = true
      
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      
      repositoryCredentials = {
        credentialsParameter = var.docker_hub_credentials_arn
      }
    }
  ])
    
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  lifecycle {
    create_before_destroy = true
  }
}
#service

resource "aws_ecs_service" "ecs-service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecs_ms_cluster.id
  task_definition = aws_ecs_task_definition.helloservice-task.arn
  desired_count   = 3
  # iam_role = "arn:aws:iam::211125578268:role/ecsTaskExecutionRole"
  launch_type     = "FARGATE"
  # depends_on      = [aws_iam_role_policy.ecs_task_execution_role_policy_attachment]

  network_configuration {
    subnets         = var.public_subnet_ids
    assign_public_ip = true
    security_groups = [ var.ecs-sg-id ]
  }
  # load_balancer {
  #   target_group_arn = aws_lb_target_group.foo.arn
  #   container_name   = "mongo"
  #   container_port   = 8080
  # }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
}