resource "aws_vpc" "md_dev_vpc_uswest2" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.environment_prefix
  }
}
