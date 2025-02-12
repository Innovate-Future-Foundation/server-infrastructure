provider "aws" {
  region = var.aws_region
}

module "jwt_secret" {
  source      = "./modules/jwt-secret"
  name        = var.name
  description = var.description
  tags        = var.tags
}

~
~
~
~
