output "public_subnet_ids" {
  value = [for subnet in aws_subnet.md_dev_subnet_uswest_public : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.md_dev_subnet_uswest_private : subnet.id]
}
