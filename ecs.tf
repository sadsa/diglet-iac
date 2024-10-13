resource "aws_ecs_cluster" "keycloak" {
  name = "keycloak-cluster"
}

resource "aws_ecs_task_definition" "keycloak" {
  family                   = "keycloak"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "keycloak"
      image = "quay.io/keycloak/keycloak:latest"
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "KC_DB"
          value = "postgres"
        },
        {
          name  = "KC_DB_URL"
          value = aws_db_instance.keycloak.endpoint
        },
        {
          name  = "KC_DB_USERNAME"
          value = "keycloak"
        },
        {
          name  = "KC_DB_PASSWORD"
          value = "keycloak123"
        },
        {
          name  = "KC_BOOTSTRAP_ADMIN_USERNAME"
          value = "admin"
        },
        {
          name  = "KC_BOOTSTRAP_ADMIN_PASSWORD"
          value = "admin123"
        },
        {
          name  = "KC_PROXY"
          value = "edge"
        },
        {
          name  = "KC_HOSTNAME_STRICT"
          value = "false"
        },
        {
          name  = "KC_HTTP_ENABLED"
          value = "true"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/keycloak"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "keycloak" {
  name            = "keycloak"
  cluster         = aws_ecs_cluster.keycloak.id
  task_definition = aws_ecs_task_definition.keycloak.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.keycloak.id]
    assign_public_ip = false
  }
}
