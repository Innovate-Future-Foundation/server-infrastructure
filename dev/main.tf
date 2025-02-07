provider "aws" {
  region = var.location

  default_tags {
    tags = local.general_tags
  }
}

locals {
  general_tags = {
    ManagedBy = "Terraform"
    Usage     = "ServerInfrastructure"
    Env       = "Development"
  }
}

module "network" {
  source   = "../modules/network"
  vpc_cidr = var.vpc_cidr
  public_subnets = {
    "api_subnet" = {
      cidr = var.api_subnet_cidr
      az   = var.subnet_az
    },
    "tool_subnet" = {
      cidr = var.tool_subnet_cidr
      az   = var.subnet_az
    }
  }

  private_subnets = {
    "preserved_subnet" = {
      cidr = var.private_subnet_cidr
      az   = var.subnet_az
    }
  }

  security_groups = {
    backend = {
      name        = "backend-sg"
      description = "Security group for dotnet api"
      ingress_rules = [{
        from_port   = 5091
        to_port     = 5091
        protocol    = "tcp"
        cidr_blocks = ["10.1.0.0/20"]
        }, {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["10.1.0.0/20", "10.1.16.0/20"]
      }]
    },
    tool = {
      name        = "web-tool-sg"
      description = "Security group for pgadmin web"
      ingress_rules = [{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.1.0.0/20", "10.1.16.0/20"]
      }]
    }
  }
}
