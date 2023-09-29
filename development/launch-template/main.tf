#EC2 Launch Template
resource "aws_launch_template" "md_dev_ec2_launch_template_uswest2" {
  name_prefix   = "md_dev_uswest2-"
  image_id      = "ami-0f3769c8d8429942f"
  instance_type = "t2.micro"

  iam_instance_profile {
    name = var.iam_profile_name
  }

  key_name = var.key_pair_name

  placement {
    # default - Multiple AWS accounts may share the same physical hardware.
    # dedicated - Your instance runs on single-tenant hardware.
    # host - Your instance runs on a physical server with EC2 instance capacity fully dedicated to your use, an isolated server with configurations that you can control.
    tenancy = "default"
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = ["${var.load_balancer_security_group_id}"]
  }

  # Minimizes contention between Amazon EBS I/O and other traffic from your instance
  ebs_optimized = false # May not be allowed on my instance type (t2.micro)

  lifecycle {
    create_before_destroy = true
  }
}
