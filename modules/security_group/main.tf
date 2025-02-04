resource "aws_security_group" "ecs_sg" {
  name        = var.sg_name
  description = "Security group for ECS services"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow API access on port 5091"
    from_port   = 5091
    to_port     = 5091
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow PgAdmin access on port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow internal Postgres access on port 5432"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
