variable "region" {
  description = "AWS Region"
  default     = "ap-southeast-2"
}

variable "cluster_name" {
  description = "ECS cluster name"
  default     = "my-backend-cluster"
}

variable "role_name" {
  description = "ECS Task Execution Role name"
  default     = "ecsTaskExecutionRole"
}

variable "ecr_repo_url" {
  description = "ECR repository URL, 585008057681.dkr.ecr.ap-southeast-2.amazonaws.com/inff-backend"
  type        = string
  default     = "585008057681.dkr.ecr.ap-southeast-2.amazonaws.com/inff-backend"
}

# Database and other environment variables
variable "db_host" {
  description = "Database host"
  default     = "postgres"
}

variable "db_port" {
  description = "Database port"
  default     = "5432"
}

variable "db_name" {
  description = "Database name"
  default     = "InnovateFuture"
}

variable "db_user" {
  description = "Database username"
  default     = "db_admin"
}

variable "db_pass" {
  description = "Database password"
  default     = "123321aab"
}

variable "jwt_secret" {
  description = "JWT secret"
  default     = "inff"
}

variable "dep_env" {
  description = "Deployment environment"
  default     = "Development"
}

variable "pg_user" {
  description = "PgAdmin default email"
  default     = "inff"
}

variable "pg_pass" {
  description = "PgAdmin default password"
  default     = "inff"
}

variable "task_cpu" {
  description = "Multi-container task CPU units"
  default     = "2048"
}

variable "task_memory" {
  description = "Multi-container task memory (MB)"
  default     = "4096"
}
