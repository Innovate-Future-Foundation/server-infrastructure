variable "region" {
  description = "AWS Region"
}

variable "ecr_region" {
  description = "The Central ECR Repository Region"
}

variable "org_abbr" {
  description = "The abbreviation of repo organisation"
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

variable "backend_repo" {
  description = "value"
  type        = string
}
