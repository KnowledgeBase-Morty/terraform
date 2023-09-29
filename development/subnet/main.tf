# Subnets for VPC (one for each availability zone)
resource "aws_subnet" "md_dev_subnet_uswest_public" {
  vpc_id                  = var.vpc_id
  count                   = length(var.public_cidr_blocks)
  cidr_block              = element(var.public_cidr_blocks, count.index)
  availability_zone       = element(var.public_availbility_zones, count.index)
  map_public_ip_on_launch = true
}

# Subnets for VPC (one for each availability zone)
resource "aws_subnet" "md_dev_subnet_uswest_private" {
  vpc_id                  = var.vpc_id
  count                   = length(var.private_cidr_blocks)
  cidr_block              = element(var.private_cidr_blocks, count.index)
  availability_zone       = element(var.private_availbility_zones, count.index)
  map_public_ip_on_launch = false
}
