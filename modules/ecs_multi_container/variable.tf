variable "family" {
  description = "Task definition family name"
  type        = string
  default     = "multi-container-task"
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

variable "execution_role_arn" {
  description = "ECS Task Execution Role ARN"
  type        = string
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

variable "ecr_repo_url" {
  description = "ECR repository URL"
  type        = string
}

variable "db_host" {
  description = "Database host"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "Database port"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_pass" {
  description = "Database password"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret"
  type        = string
}

variable "dep_env" {
  description = "Deployment environment"
  type        = string
}

variable "pg_user" {
  description = "PgAdmin default email"
  type        = string
}

variable "pg_pass" {
  description = "PgAdmin default password"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
