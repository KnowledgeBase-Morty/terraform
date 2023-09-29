output "esc_cluster_name" {
  value = aws_ecs_cluster.md_dev_ecs_cluster.name
}

output "esc_service_name" {
  value = aws_ecs_service.app_service.name
}
