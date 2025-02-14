provider "aws" {
  region = var.aws_region
}

module "secrets-manager" {
  source      = "./modules/secrets-manager"
  secrets     = {secrets="secret1"}
  description = var.description
  tags        = var.tags
}


