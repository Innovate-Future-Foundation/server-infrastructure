resource "aws_cloudwatch_log_group" "this" {
  for_each          = toset(var.log_groups)
  name              = each.key
  retention_in_days = 14
}
