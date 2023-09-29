# Test connection from inside EC2: mysql -h md-rds-dev.csj5cxmfobjt.us-west-2.rds.amazonaws.com --user="md_rds_dev_root" --password="Th$sIsMyPassword142!" -P 3306 MortensenDevelopment
resource "aws_db_instance" "md_dev_rds_uswest2" {
  engine                  = "mysql"
  identifier              = "md-rds-dev"
  allocated_storage       = 20
  engine_version          = "8.0.33"
  instance_class          = "db.t2.micro"
  username                = "md_rds_dev_root"
  password                = "Th$sIsMyPassword142!"
  parameter_group_name    = "default.mysql8.0"
  db_name                 = "MortensenDevelopment"
  db_subnet_group_name    = var.rds_subnet_group_name
  vpc_security_group_ids  = [var.rds_security_group_id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = 7
  backup_window           = "01:00-02:00"
}
