# resource "aws_iam_role" "ec2_service_role" {
#   name = "ec2_scaling_role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "tag-value"
#   }
# }

# resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
#   role       = aws_iam_role.ecs-instance-role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }

# resource "aws_iam_instance_profile" "ecs_service_role" {
#   role = aws_iam_role.ecs-instance-role.name
# }
