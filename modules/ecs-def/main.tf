locals {
  default_task_execution_policy = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create an ECS cluster 
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

# Defualt task execution role
data "aws_iam_policy_document" "role_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "task_role" {
  for_each           = var.families
  name               = each.value.role
  assume_role_policy = data.aws_iam_policy_document.role_assume_policy.json
}

resource "aws_iam_policy_attachment" "task_policy" {
  for_each   = var.families
  name       = "${each.value.role}-policy-attachment"
  roles      = [aws_iam_role.task_role[each.key].name]
  policy_arn = local.default_task_execution_policy
}

# Task definitions
resource "aws_ecs_task_definition" "this" {
  for_each = var.families
  family   = each.value.name
  cpu      = each.value.cpu
  memory   = each.value.mem

  execution_role_arn    = aws_iam_role.task_role[each.key].arn
  container_definitions = each.value.containers

  # Do not track containers configuration
  lifecycle {
    ignore_changes = [container_definitions]
  }
}
