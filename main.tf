provider "aws" {
  region = var.aws_region
}

module "secrets-manager" {
  source      = "./modules/secrets-manager"
  description = var.description
  tags        = var.tags
}
