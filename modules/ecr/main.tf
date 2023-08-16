resource "aws_ecr_repository" "repo" {
  name                 = var.name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = var.is_scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "repo-policy" {
  repository = aws_ecr_repository.repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.image_limit} images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = [var.tag_prefix]
          countType     = "imageCountMoreThan"
          countNumber   = var.image_limit
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "delete untagged image"
        selection = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

}
