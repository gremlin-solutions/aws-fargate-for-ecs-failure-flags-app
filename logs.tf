resource "aws_cloudwatch_log_group" "ecs_app_log_group" {
  name              = "/ecs/s3-failure-flags-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "ecs_sidecar_log_group" {
  name              = "/ecs/s3-failure-flags-sidecar"
  retention_in_days = 7
}

