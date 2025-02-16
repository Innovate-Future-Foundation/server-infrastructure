resource "aws_cloudwatch_log_group" "main" {
  for_each          = var.log_groups
  name              = each.value.name
  retention_in_days = each.value.retention
}
