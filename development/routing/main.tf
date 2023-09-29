resource "aws_route_table" "md_dev_routetable_uswest2_public" {
  vpc_id = var.vpc_id

  tags = {
    name = "md_dev_routetable_uswest2_public"
  }
}

resource "aws_route_table" "md_dev_routetable_uswest2_private" {
  vpc_id = var.vpc_id

  tags = {
    name = "md_dev_routetable_uswest2_private"
  }
}

# Route for Internet Gateway
resource "aws_route" "md_dev_internet_gateway_route_uswest2_public" {
  route_table_id         = aws_route_table.md_dev_routetable_uswest2_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# Route for NAT
resource "aws_route" "md_dev_nat_route_uswest2_private" {
  route_table_id         = aws_route_table.md_dev_routetable_uswest2_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(var.public_subnet_ids, count.index)
  route_table_id = aws_route_table.md_dev_routetable_uswest2_public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(var.private_subnet_ids, count.index)
  route_table_id = aws_route_table.md_dev_routetable_uswest2_private.id
}
