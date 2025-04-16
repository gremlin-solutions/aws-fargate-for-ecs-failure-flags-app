# ===========================================================================
# Input Variables
# ===========================================================================
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "s3-failure-flags-cluster"
}

variable "ecs_service_desired_count" {
  description = "Desired number of tasks for the ECS service"
  type        = number
  default     = 2
}

variable "app_image" {
  description = "ECR image URL for the s3-failure-flags-app"
  type        = string
  default     = "jsabo/s3-failure-flags-app:latest"
}

variable "gremlin_sidecar_image" {
  description = "Docker image for Gremlin Failure Flags sidecar"
  type        = string
  default     = "gremlin/failure-flags-sidecar:latest"
}

variable "container_port" {
  description = "Port the application container listens on"
  type        = number
  default     = 8080
}

variable "app_environment" {
  description = "Environment variables for the application container"
  type        = map(string)
  default = {
    S3_BUCKET             = "commoncrawl"
    FAILURE_FLAGS_ENABLED = "true"
    CLOUD                 = "aws"
  }
}

variable "gremlin_team_id_path" {
  description = "Path to the file with the Gremlin Team ID"
  type        = string
  default     = "gremlin_team_id.txt"
}

variable "gremlin_team_certificate_path" {
  description = "Path to the file with the Gremlin Team certificate"
  type        = string
  default     = "gremlin_team_certificate.pem"
}

variable "gremlin_team_private_key_path" {
  description = "Path to the file with the Gremlin Team private key"
  type        = string
  default     = "gremlin_team_private_key.pem"
}

