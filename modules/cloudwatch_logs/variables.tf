variable "log_groups" {
  description = "Map of log group names"
  type = map(object({
    name      = string
    retention = number
  }))
}
