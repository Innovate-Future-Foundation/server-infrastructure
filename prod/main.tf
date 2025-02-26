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
        from_port   = 5091
        to_port     = 5091
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr]
        }, {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr, var.tool_subnet_cidr]
      }]
    },
    tool = {
      name        = "web-tool-sg"
      description = "Security group for pgadmin web"
      ingress_rules = [{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr, var.tool_subnet_cidr]
      }]
    }
  }
}

locals {
  vpc_name            = "inff-prod-main"
  vpc_cidr            = "10.1.0.0/16"
  api_subnet_cidr     = "10.1.0.0/20"
  tool_subnet_cidr    = "10.1.16.0/20"
  private_subnet_cidr = "10.1.32.0/20"
  subnet_az           = "ap-southeast-2a"
}

module "iam" {
  source    = "../modules/iam"
  role_name = var.role_name
}

module "cloudwatch" {
  source = "../modules/cloudwatch_logs"
  log_groups = {
    ecs_default = {
      name      = var.ecs_logs_group
      retention = 14
    }
  }
}

module "cloud_map" {
  source      = "../modules/cloud-map"
  namespace   = "inff-dev-ns"
  description = "Namespace for InFF Dev Enviroment"
  vpc_id      = module.network.vpc_id

  services = {
    backend = {
      name = "api"
      dns_records = [{
        ttl  = 10
        type = "SRV"
        }, {
        ttl  = 10
        type = "A"
      }]
    }
  }
}

module "ecr" {
  source = "../modules/ecr"

  repositories = {
    backend-publish = {
      name        = "inff/backend-publish"
      description = "API server container images"
    }
    backend-base = {
      name        = "inff/backend-base"
      description = "Base server container images"
    }
  }
}

output "api_gateway_endpoint" {
  description = "API Gateway endpoint URL"
  value       = module.api_gateway.api_endpoint
}
