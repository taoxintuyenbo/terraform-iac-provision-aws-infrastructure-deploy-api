resource "aws_db_subnet_group" "mydb" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.database_subnet

  tags = {
    Name = "${var.name}-db-subnet-group"
  }
}

resource "aws_db_instance" "mydb" {
  allocated_storage           = 10
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = var.db_instance_class

  db_name                     = var.dbname
  username                    = var.username
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.mydb.name
  vpc_security_group_ids = [var.rds_mysql_sg_id]
  publicly_accessible    = false

  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false

  parameter_group_name        = "default.mysql8.0"
}