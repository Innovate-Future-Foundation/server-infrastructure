resource "aws_security_group" "main" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.name
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  type        = "ingress"
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.cidr_blocks
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "egress" {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
  type             = "egress"
}
