resource "aws_ecr_repository" "umf_prod_ecr" {
  name                 = "umf-backend-prod"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
