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
  default     = "ecsTestTaskExecutionRole"
}

variable "ecs_logs_group" {
  description = "CloudWatch logs group for backend service on ecs"
  default     = "ecs/default_log_group"
  type        = string
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
  description = "Postgres DB port number"
  type        = number
  default     = 5432
}
variable "api_port" {
  description = "Dotnet API port number"
  type        = number
  default     = 5091
}
variable "web_port" {
  description = "General Web port number"
  type        = number
  default     = 80
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
  default     = "inff@inff.com"
}

variable "pg_pass" {
  description = "PgAdmin default password"
  default     = "inff"
}

variable "task_cpu" {
  description = "Multi-container task CPU units"
  default     = "512"
}
variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "test-inff-dev-main"
}
variable "vpc_cidr" {
  description = "CIDR for vpc"
  type        = string
  default     = "10.1.0.0/16"
}
variable "api_subnet_cidr" {
  description = "CIDR block for ecs resources"
  type        = string
  default     = "10.1.0.0/20"
}

variable "task_memory" {
  description = "Multi-container task memory (MB)"
  default     = "1024"
}
variable "tool_subnet_cidr" {
  description = "CIDR block for tool resources"
  type        = string
  default     = "10.1.16.0/20"
}
variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  default     = "10.1.32.0/20"
}
variable "anywhere_cidr" {
  description = "wildcard cidr"
  default     = "0.0.0.0/0"
}
variable "subnet_az" {
  description = "subnet availability zone"
  type        = string
  default     = "ap-southeast-2a"
}
