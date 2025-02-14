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
  vpc_name = "${var.vpc_name}-vpc"
  vpc_cidr = var.vpc_cidr
  public_subnets = {
    "api-subnet" = {
      cidr = var.api_subnet_cidr
      az   = var.subnet_az
    },
    "tool-subnet" = {
      cidr = var.tool_subnet_cidr
      az   = var.subnet_az
    }
  }

  private_subnets = {
    "preserved-subnet" = {
      cidr = var.private_subnet_cidr
      az   = var.subnet_az
    }
  }

  security_groups = {
    backend = {
      name        = "backend-sg"
      description = "Security group for dotnet api"
      ingress_rules = [{
        from_port   = var.api_port
        to_port     = var.api_port
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr]
        }, {
        from_port   = var.db_port
        to_port     = var.db_port
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr, var.tool_subnet_cidr]
      }]
    },
    tool = {
      name        = "web-tool-sg"
      description = "Security group for pgadmin web"
      ingress_rules = [{
        from_port   = var.web_port
        to_port     = var.web_port
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr, var.tool_subnet_cidr]
      }]
    }
  }
}

module "cloud_map" {
  source      = "../modules/cloud-map"
  namespace   = "inff-dev-ns"
  description = "Namespace for InFF Dev Enviroment"
  vpc_id      = module.network.vpc_id
}

module "ecr" {
  source = "../modules/ecr"

  repositories = {
    api-server = {
      name        = "inff/backend-publish"
      description = "API server container images"
    }
    base-server = {
      name        = "inff/base-server"
      description = "Base server container images"
    }
  }

  tags = local.general_tags
}