output "load_balancer_id" {
  value = aws_alb.md_dev_loadbalancer_uswest2.id
}

output "load_balancer_endpoint" {
  value = aws_alb.md_dev_loadbalancer_uswest2.dns_name
}

output "load_balancer_target_group_arn" {
  value = aws_lb_target_group.md_dev_loadbalancer_targetgroup_uswest2.arn
}
