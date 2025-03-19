
resource "aws_ecr_repository" "portfolio_repo" {
  name                 = "portfolio-app"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  encryption_configuration {
    encryption_type = "AES256"
  }
}
