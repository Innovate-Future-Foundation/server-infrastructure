variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for the ALB"
  type        = list(string)
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}
