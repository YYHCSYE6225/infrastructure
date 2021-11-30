resource "aws_db_parameter_group" "mysql_parameter_group" {
  name   = var.db_parameter_group_name
  family = var.db_parameter_group_family

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "mysql_db_instance" {
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  availability_zone       = "us-east-1a"
  multi_az                = false
  identifier              = var.db_identifier
  username                = var.db_username
  password                = var.db_password
  publicly_accessible     = true
  name                    = var.db_name
  parameter_group_name    = aws_db_parameter_group.mysql_parameter_group.name
  vpc_security_group_ids  = [aws_security_group.database.id]
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot     = true
  backup_retention_period = 1
}

resource "aws_db_instance" "mysql_db_instance_2" {
  instance_class    = var.db_instance_class
  availability_zone = "us-east-1b"
  multi_az          = false
  identifier        = "csye6225-2"
  publicly_accessible    = true
  name                   = "csye6225_2"
  parameter_group_name   = aws_db_parameter_group.mysql_parameter_group.name
  vpc_security_group_ids = [aws_security_group.database.id]
  skip_final_snapshot    = true
  replicate_source_db    = aws_db_instance.mysql_db_instance.identifier
}