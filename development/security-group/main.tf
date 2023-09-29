# Create a security groups for the load balancer (public)
resource "aws_security_group" "md_dev_loadbalancer_securitygroup_uswest2" {
  name   = "md_dev_loadbalancer_securitygroup_uswest2"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.199.2.56/32"] # Only allows my IP address for SSH
  }
  ingress {
    from_port   = 80
    to_port     = 80 ## TODO: Switch to 443 once certificate is approved
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for RDS Database Instance (private)
resource "aws_security_group" "md_dev_rds_securitygroup_uswest2" {
  name   = "md_rds_sg_dev_uswest2"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.md_dev_loadbalancer_securitygroup_uswest2.id}"] # Only accessible from Elastic Beanstalk EC2 instance
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["71.199.2.56/32"] # Only allows my IP address for SSH
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "md_dev_rds_subnetgroup_uswest2" {
  name       = "md_dev_rds_subnetgroup_uswest2"
  subnet_ids = var.private_subnet_ids
}
