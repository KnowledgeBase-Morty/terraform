resource "aws_nat_gateway" "md_dev_nat_uswest2" {
  allocation_id = var.elastic_ip_id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "md_dev_nat_uswest2"
  }
}
