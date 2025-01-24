variable "service_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "task_definition_arn" {
  type        = string
  description = "ARN of the task definition"
}

variable "desired_count" {
  type        = number
  description = "Number of desired tasks"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the ECS service"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for the ECS service"
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the target group for the ALB"
}

variable "container_name" {
  type        = string
  description = "The name of the container to register with the target group"
}

variable "container_port" {
  type        = number
  description = "The container port exposed to the ALB"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
}

variable "cloudmap_service_arn" {
  type        = string
  description = "The ARN of the CloudMap service"
}