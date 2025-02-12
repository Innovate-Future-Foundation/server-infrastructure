provider "aws" {
  region = var.aws_region
}

module "secrets-manager" {
  source      = "./modules/secrets-manager"
  secrets     = var.secrets
  description = var.description
  tags        = var.tags
}
