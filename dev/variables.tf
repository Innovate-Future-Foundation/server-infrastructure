variable "region" {
  description = "AWS Region"
  default     = "ap-southeast-2"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default     = "inff-dev-backend"
}

variable "ecs_family_name" {
  description = "ECS Task Defninition Family namee"
  default     = "inff-dev-api-db-set"
}

variable "ecs_service_name" {
  description = "ECS Service name for api db set in dev"
  default     = "inff-dev-api-db-set"
}

variable "role_name" {
  description = "ECS Task Execution Role name"
  default     = "ecsTestTaskExecutionRole"
}

variable "ecs_logs_group" {
  description = "CloudWatch logs group for backend service on ecs"
  default     = "inff/ecs/default_log_group"
  type        = string
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "inff-dev-main"
}

variable "vpc_cidr" {
  description = "CIDR for vpc"
  type        = string
  default     = "10.1.0.0/16"
}

variable "api_subnet_cidr" {
  description = "CIDR block for ecs resources"
  type        = string
  default     = "10.1.0.0/20"
}

variable "tool_subnet_cidr" {
  description = "CIDR block for tool resources"
  type        = string
  default     = "10.1.16.0/20"
}
variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  default     = "10.1.32.0/20"
}
variable "anywhere_cidr" {
  description = "wildcard cidr"
  default     = "0.0.0.0/0"
}
variable "subnet_az" {
  description = "subnet availability zone"
  type        = string
  default     = "ap-southeast-2a"
}

variable "central_ecr_base_repo_uri" {
  description = "Central ECR Base image URI"
  type        = string
}

variable "central_ecr_publish_repo_uri" {
  description = "Central ECR Publish image URI"
  type        = string
}
