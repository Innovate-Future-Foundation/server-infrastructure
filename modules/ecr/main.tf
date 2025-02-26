terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1"
    }
  }
}

resource "aws_ecr_repository" "repo" {
  for_each             = var.repositories
  name                 = each.value.name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    var.tags,
    {
      Name = each.value.name
      Desc = each.value.description
    }
  )
}

resource "aws_ecr_lifecycle_policy" "policy" {
  for_each   = var.repositories
  repository = aws_ecr_repository.repo[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
