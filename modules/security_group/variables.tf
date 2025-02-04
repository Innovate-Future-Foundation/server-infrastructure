variable "sg_name" {
  description = "Security group name"
  type        = string
  default     = "ecs-sg"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}
