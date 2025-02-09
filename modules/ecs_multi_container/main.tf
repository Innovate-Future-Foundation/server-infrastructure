# Create an ECS cluster 
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

# Define a multi-container task with four containers: postgres, migration, api, pgadmin
resource "aws_ecs_task_definition" "multi" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      "name": "postgres",
      "image": "postgres:17.2",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5432,
          "hostPort": 5432,
          "protocol": "tcp"
        }
      ],
      "environment": [
        { "name": "POSTGRES_USER", "value": var.db_user },
        { "name": "POSTGRES_PASSWORD", "value": var.db_pass },
        { "name": "POSTGRES_DB", "value": var.db_name }
      ],
      "healthCheck": {
        "command": [
          "CMD-SHELL",
          "PGPASSWORD=${var.db_pass} psql -U ${var.db_user} -h localhost -p 5432 -d ${var.db_name} -c 'SELECT 1'"
        ],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 10
      }
    },
    {
      "name": "migration",
      "image": "${var.ecr_repo_url}:inff-api-build",
      "essential": false,
      "command": [
        "sh",
        "-c",
        "dotnet ef database update --project src/InnovateFuture.Infrastructure/InnovateFuture.Infrastructure.csproj --startup-project src/InnovateFuture.Api/InnovateFuture.Api.csproj"
      ],
      "dependsOn": [
        {
          "containerName": "postgres",
          "condition": "HEALTHY"
        }
      ],
      "environment": [
        { "name": "DBConnection", "value": "Host=localhost;Port=${var.db_port};Database=${var.db_name};Username=${var.db_user};Password=${var.db_pass};" },
        { "name": "JWTConfig__SecretKey", "value": var.jwt_secret },
        { "name": "ASPNETCORE_ENVIRONMENT", "value": var.dep_env }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": module.cloudwatch_logs.log_group_names["migration"],
          "awslogs-region": var.region,
          "awslogs-stream-prefix": "migration"
        }
      }
    },
    {
      "name": "api",
      "image": "${var.ecr_repo_url}:my-backend-api",
      "essential": true,
      "portMappings": [
        {
          "containerPort": "${var.api_port}", 
          "hostPort": "${var.api_port}",
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "DBConnection",
          "value": "Host=localhost;Port=${var.db_port};Database=${var.db_name};Username=${var.db_user};Password=${var.db_pass};"
        },
        { "name": "JWTConfig__SecretKey", "value": var.jwt_secret },
        { "name": "ASPNETCORE_ENVIRONMENT", "value": var.dep_env },
        { "name": "ASPNETCORE_URLS", "value": "http://+:5091/" }
      ],
      "dependsOn": [
        {
          "containerName": "migration",
          "condition": "COMPLETE"
        },
        {
          "containerName": "postgres",
          "condition": "HEALTHY"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": module.cloudwatch_logs.log_group_names["api"],
          "awslogs-region": var.region,  // temporarily hardcoded for troubleshooting
          "awslogs-stream-prefix": "api"
        }
      }
    },
    {
      "name": "pgadmin",
      "image": "${var.ecr_repo_url}:my-pgadmin",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "environment": [
        { "name": "PGADMIN_DEFAULT_EMAIL", "value": var.pg_user },
        { "name": "PGADMIN_DEFAULT_PASSWORD", "value": var.pg_pass }
      ],
      "dependsOn": [
        {
          "containerName": "postgres",
          "condition": "HEALTHY"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": module.cloudwatch_logs.log_group_names["pgadmin"],
          "awslogs-region": var.region,
          "awslogs-stream-prefix": "pgadmin"
        }
      }
    }
  ])
}

# Create an ECS service to run the multi-container task
resource "aws_ecs_service" "multi_service" {
  name            = "multi-container-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.multi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }
}
