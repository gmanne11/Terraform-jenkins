variable "db_subnet_group_name" {}
variable "subnet_ids" {}
variable "mysql_db_identifier" {}
variable "mysql_username" {}
variable "mysql_password" {}
variable "rds_mysql_sg_id" {}
variable "mysql_dbname" {}


output "mysql_dbname" {
    value = aws_db_instance.default.db_name
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids # replace with your private subnet IDs
}

# Create RDS DB instance
resource "aws_db_instance" "default" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7.44"
  instance_class          = "db.t3.micro"
  identifier              = var.mysql_db_identifier
  username                = var.mysql_username
  password                = var.mysql_password
  vpc_security_group_ids  = [var.rds_mysql_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.rds_db_subnet_group.name
  db_name                 = var.mysql_dbname
  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false
}