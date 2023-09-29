resource "aws_internet_gateway" "md_dev_igw_uswest2" {
  vpc_id = var.vpc_id
  tags = {
    Name = "md_dev_igw_uswest2"
  }
}
