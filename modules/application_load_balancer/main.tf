resource "aws_lb" "main" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# Path-based routing rule for pgadmin
resource "aws_lb_listener_rule" "pgadmin_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  condition {
    path_pattern {
      values = ["/pgadmin/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# Path-based routing rule for dotnet-app
resource "aws_lb_listener_rule" "dotnet_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 2

  condition {
    path_pattern {
      values = ["/app/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
