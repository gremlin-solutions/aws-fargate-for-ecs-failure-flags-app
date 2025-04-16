# ===========================================================================
# Output Values
# ===========================================================================
output "load_balancer_dns" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app_lb.dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

