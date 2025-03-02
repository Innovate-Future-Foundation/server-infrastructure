variable "region" {
  description = "AWS Region"
  default     = "ap-southeast-2"
}

variable "ecs_logs_group" {
  description = "CloudWatch logs group for backend service on ecs"
  default     = "inff/ecs/default_log_group"
  type        = string
}

variable "anywhere_cidr" {
  description = "wildcard cidr"
  default     = "0.0.0.0/0"
}

variable "central_ecr_base_repo_uri" {
  description = "Central ECR Base image URI"
  type        = string
}

variable "central_ecr_publish_repo_uri" {
  description = "Central ECR Publish image URI"
  type        = string
}
