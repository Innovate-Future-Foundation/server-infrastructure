variable "family" {
  description = "Task definition family name"
  type        = string
  default     = "multi-container-task"
}

variable "container_definitions" {
  description = "Container definitions block in ECS task definition"
  type        = string
}

variable "service_name" {
  description = "Name of ECS service"
  type        = string
}

variable "cpu" {
  description = "Task CPU units"
  type        = string
  default     = "2048"
}

variable "memory" {
  description = "Task memory (MB)"
  type        = string
  default     = "4096"
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = true
}

variable "registry_arn" {
  description = "Discovery Service ARN"
  type        = string
}

variable "task_execution_role" {
  description = "The task execution role for task definition"
  type        = string
  default     = "backend-ecs-role"
}
