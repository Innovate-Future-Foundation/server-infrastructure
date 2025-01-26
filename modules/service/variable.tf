variable "cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

variable "subnets" {
  description = "Subnets for ECS services"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for ECS services"
  type        = list(string)
}

variable "postgres_task_arn" {
  description = "ARN of the Postgres Task Definition"
  type        = string
}

variable "migration_task_arn" {
  description = "ARN of the Migration Task Definition"
  type        = string
}

variable "api_task_arn" {
  description = "ARN of the API Task Definition"
  type        = string
}
