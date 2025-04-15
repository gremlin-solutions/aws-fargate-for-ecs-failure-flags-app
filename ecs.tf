# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# ECS Task Definition including both the app and the Gremlin sidecar
resource "aws_ecs_task_definition" "s3_failure_flags_task" {
  family                   = "s3-failure-flags-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "app-container"
      image = var.app_image
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        for key, value in var.app_environment : {
          name  = key
          value = value
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_app_log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "app"
        }
      }
    },
    {
      name      = "gremlin-sidecar"
      image     = var.gremlin_sidecar_image
      essential = false
      environment = [
        {
          name  = "GREMLIN_SIDECAR_ENABLED"
          value = "true"
        },
        {
          name  = "GREMLIN_DEBUG"
          value = "true"
        },
        {
          name  = "SERVICE_NAME"
          value = "s3-failure-flags-app"
        },
        {
          name  = "GREMLIN_TEAM_ID"
          value = data.local_file.gremlin_team_id.content
        },
        {
          name  = "GREMLIN_TEAM_CERTIFICATE"
          value = data.local_sensitive_file.gremlin_team_certificate.content
        },
        {
          name  = "GREMLIN_TEAM_PRIVATE_KEY"
          value = data.local_sensitive_file.gremlin_team_private_key.content
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_sidecar_log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "sidecar"
        }
      }
    }
  ])
}

# ECS Service (Fargate) with ALB integration
resource "aws_ecs_service" "ecs_service" {
  name             = "s3-failure-flags-service"
  cluster          = aws_ecs_cluster.ecs_cluster.id
  task_definition  = aws_ecs_task_definition.s3_failure_flags_task.arn
  desired_count    = var.ecs_service_desired_count
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "app-container"
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_listener.app_lb_listener
  ]
}

