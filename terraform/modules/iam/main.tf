# resource "aws_iam_role" "ecstaskexecution_role" {
#   name = var.role_name

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = "ecsTaskExecutionRole"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "ecs-task-execution-role"
#   }
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
#   role       = aws_iam_role.ecstaskexecution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_iam_role_policy_attachment" "ecs_ssm_readonly_policy" {
#   role       = aws_iam_role.ecstaskexecution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
# }


# # resource "aws_iam_policy" "ecs_passrole_policy" {
# #   name        = "ecs-passrole-policy"
# #   description = "Allow iam:PassRole for ECS task execution role"

# #   policy = jsonencode({
# #     Version = "2012-10-17"
# #     Statement = [
# #       {
# #         Effect   = "Allow"
# #         Action   = "iam:PassRole"
# #         Resource = "arn:aws:iam::211125578268:role/ecstaskexecution_role"
# #         Condition = {
# #           StringEquals = {
# #             "iam:PassedToService" = "ecs-tasks.amazonaws.com"
# #           }
# #         }
# #       }
# #     ]
# #   })
# # }

# # # Attach this policy to your Terraform user or role
# # resource "aws_iam_user_policy_attachment" "ecs_passrole_attach" {
# #   user       = "kk_labs_user_409913"   # replace with your IAM user name
# #   policy_arn = aws_iam_policy.ecs_passrole_policy.arn
# # }


# resource "aws_iam_role" "terraform_role" {
#   name = "terraform-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         AWS = "arn:aws:iam::211125578268:user/kk_labs_user_409913"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_passrole_attach" {
#   role       = aws_iam_role.terraform_role.name
#   policy_arn = "arn:aws:iam::211125578268:policy/ecs-passrole-policy"
# }
