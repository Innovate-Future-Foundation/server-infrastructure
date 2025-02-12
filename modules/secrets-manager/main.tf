terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.43.0"
    }
  }
}

# Secret-1
resource "random_string" "secret-1" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_secretsmanager_secret" "secret-1" {
  name = "secret-1"
}

resource "aws_secretsmanager_secret_version" "secret-1_version" {
  secret_id     = aws_secretsmanager_secret.secret-1.id
  secret_string = base64encode(random_string.secret-1.result)
}

# Secret-2
resource "random_string" "secret-2" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_secretsmanager_secret" "secret-2" {
  name = "secret-2"
}

resource "aws_secretsmanager_secret_version" "secret-2_version" {
  secret_id     = aws_secretsmanager_secret.secret-2.id
  secret_string = base64encode(random_string.secret-2.result)
}

# Secret-3
resource "random_string" "secret-3" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_secretsmanager_secret" "secret-3" {
  name = "secret-3"
}

resource "aws_secretsmanager_secret_version" "secret-3_version" {
  secret_id     = aws_secretsmanager_secret.secret-3.id
  secret_string = base64encode(random_string.secret-3.result)
}
