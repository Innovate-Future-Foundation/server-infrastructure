locals {
  # Network Settings
  vpc = {
    main = {
      vpc_name = "inff-prod-main"
      cidr     = "10.1.0.0/16"
      public_subnets = {
        api-a-subnet = {
          cidr = "10.1.0.0/20"
          az   = "us-west-2a"
        }
        api-b-subnet = {
          cidr = "10.1.16.0/20"
          az   = "us-west-2b"
        },
        tool-subnet = {
          cidr = "10.1.32.0/20"
          az   = "us-west-2a"
        },
      }
      private_subnet = {
        preserved-subnet = {
          cidr = "10.1.48.0/20"
          az   = "us-west-2a"
        },
      }
    }
  }
  # ECS Settings
  task_execution_role     = "inff-backend-ecs-role"
  central_ecr_repo_policy = data.aws_iam_policy_document.central_ecr_repo_policy.json
}

module "network" {
  source          = "../modules/network"
  vpc_name        = "${local.vpc.main.vpc_name}-vpc"
  vpc_cidr        = local.vpc.main.cidr
  public_subnets  = local.vpc.main.public_subnets
  private_subnets = local.vpc.main.private_subnet

  security_groups = {
    backend = {
      name        = "backend-sg"
      description = "Security group for dotnet api"
      ingress_rules = [{
        from_port = 5091
        to_port   = 5091
        protocol  = "tcp"
        cidr_blocks = [
          local.vpc.main.public_subnets.api-a-subnet.cidr,
          local.vpc.main.public_subnets.api-b-subnet.cidr,
        ] }, {
        from_port = 5432
        to_port   = 5432
        protocol  = "tcp"
        cidr_blocks = [
          local.vpc.main.public_subnets.api-a-subnet.cidr,
          local.vpc.main.public_subnets.api-b-subnet.cidr,
          local.vpc.main.public_subnets.tool-subnet.cidr
        ] }
      ]
    },
  }
}

module "cloud_map" {
  source      = "../modules/cloud-map"
  namespace   = "inff-prod-ns"
  description = "Namespace for InFF Prod Enviroment"
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
  providers = { aws = aws.central_ecr }
  source    = "../modules/ecr"

  repositories = {
    backend-publish = {
      name        = "inff/backend-publish"
      description = "API server container images"
      policy      = local.central_ecr_repo_policy
    }
    backend-base = {
      name        = "inff/backend-base"
      description = "Base server container images"
      policy      = local.central_ecr_repo_policy
    }
  }
}
