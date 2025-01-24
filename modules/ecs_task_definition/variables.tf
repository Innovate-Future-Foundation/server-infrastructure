variable "family" {
  type        = string
  description = "Name of the task definition family"
}

variable "cpu" {
  type        = string
  description = "CPU units for the task"
}

variable "memory" {
  type        = string
  description = "Memory for the task"
}

variable "execution_role_arn" {
  type        = string
  description = "IAM execution role ARN for the task"
}

variable "container_definitions" {
  type        = any
  description = "JSON-encoded container definitions"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
}
