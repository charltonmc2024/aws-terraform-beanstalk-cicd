resource "aws_ecr_repository" "nginx" {

  name         = "${var.app_name}-repo"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "${var.app_name}-ecr"
  }
}
