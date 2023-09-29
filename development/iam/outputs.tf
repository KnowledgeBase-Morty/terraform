output "role_id" {
  value = aws_iam_role.md_eb_role_dev_uswest2.id
}

output "role_name" {
  value = aws_iam_role.md_eb_role_dev_uswest2.name
}

output "profile_id" {
  value = aws_iam_instance_profile.md_ec2_profile_dev_uswest2.id
}

output "profile_name" {
  value = aws_iam_instance_profile.md_ec2_profile_dev_uswest2.name
}
