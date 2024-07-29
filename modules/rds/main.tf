provider "aws" {
  region = var.region
}

resource "aws_db_instance" "rds_instance" {
  identifier           = "rds-oracle"
  engine               = "oracle-ee"
  engine_version       = "19.0.0.0.ru-2019-07.rur-2019-07.r1"
  instance_class       = var.instance_class
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  license_model        = var.license_model
  parameter_group_name = "default.oracle-ee-19"
  allocated_storage    = var.allocated_storage
  storage_encrypted    = false
  skip_final_snapshot  = true

  tags = {
    Name = "My-RDS-Oracle"
  }
}
