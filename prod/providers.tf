provider "aws" {
  region = var.region
  default_tags {
    tags = local.general_tags
  }
}

provider "aws" {
  alias  = "central_ecr"
  region = var.ecr_region
  default_tags {
    tags = local.general_tags
  }
}

locals {
  general_tags = {
    ManagedBy = "Terraform"
    Usage     = "ServerInfrastructure"
    Env       = "Production"
  }
}
