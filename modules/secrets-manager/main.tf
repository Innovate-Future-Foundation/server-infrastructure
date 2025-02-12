terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.43.0"
    }
  }
}

resource "random_string" "jwt_secret" {
  length           = 32
  special          = false
  upper            = true
  lower            = true
  numeric          = true
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name        = var.name
  description = var.description

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "jwt_secret_version" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = base64encode(random_string.jwt_secret.result)
}
