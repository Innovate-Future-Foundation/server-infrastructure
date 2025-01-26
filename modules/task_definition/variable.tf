variable "db_user" {
  description = "Postgres database user"
  type        = string
}

variable "db_password" {
  description = "Postgres database password"
  type        = string
}

variable "db_name" {
  description = "Postgres database name"
  type        = string
}

variable "db_host" {
  description = "Database host for dependent services"
  type        = string
}

variable "migration_image" {
  description = "ECR image for the migration container"
  type        = string
}

variable "api_image" {
  description = "ECR image for the API container"
  type        = string
}
