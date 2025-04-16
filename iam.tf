# ===========================================================================
# IAM Roles & Policies
#   • ecs_task_execution_role: ECS image-pull & CloudWatch logging
#   • ecs_task_role: S3 read permissions for application code
# ===========================================================================
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "s3-failure-flags-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "s3-failure-flags-ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ecs_task_s3_read_policy" {
  name = "s3-failure-flags-ecsTaskS3Read"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:ListBucket"],
        Resource = ["arn:aws:s3:::commoncrawl"]
      },
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject"],
        Resource = ["arn:aws:s3:::commoncrawl/*"]
      }
    ]
  })
}

