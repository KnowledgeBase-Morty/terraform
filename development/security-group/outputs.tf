output "load_balancer_security_group_id" {
  value = aws_security_group.md_dev_loadbalancer_securitygroup_uswest2.id
}

output "load_balancer_security_group_name" {
  value = aws_security_group.md_dev_loadbalancer_securitygroup_uswest2.name
}

output "rds_security_group_id" {
  value = aws_security_group.md_dev_rds_securitygroup_uswest2.id
}

output "rds_security_group_name" {
  value = aws_security_group.md_dev_rds_securitygroup_uswest2.name
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.md_dev_rds_subnetgroup_uswest2.name
}
