variable "region" {
  description = "AWS Region"
}

variable "ecr_region" {
  description = "The Central ECR Repository Region"
}

variable "dev_account_id" {
  description = "value"
  type        = string
}

variable "uat_account_id" {
  description = "value"
  type        = string
}

variable "prod_account_id" {
  description = "value"
  type        = string
}

variable "backend_workflow_role" {
  description = "value"
  type        = string
}
