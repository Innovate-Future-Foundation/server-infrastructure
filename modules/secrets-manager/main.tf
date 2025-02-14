terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.43.0"
    }
  }
}

# Input variable to define secrets
variable "secrets" {
  description = "A map of secrets to be created"
  type        = map(string)
}

# Random string generation for each secret
resource "random_string" "secrets" {
  for_each = var.secrets
  length   = 32
  special  = false
  upper    = true
  lower    = true
  numeric  = true
}

# AWS Secrets Manager secret creation for each secret
resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets
  name     = each.value
}

# AWS Secrets Manager secret version creation for each secret
resource "aws_secretsmanager_secret_version" "secrets_version" {
  for_each      = var.secrets
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = random_string.secrets[each.key].result
}
