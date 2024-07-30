terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My Oracle DB subnet group"
  }
}

resource "aws_security_group" "allow_ssh" {
  name   = "allow ssh traffic"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 65535
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

module "rds" {
  source                  = "./modules/rds"
  region                  = "us-west-2"
  allocated_storage       = 20
  storage_type            = "gp2"
  instance_class          = "db.m5.large"
  db_name                 = "mydb"
  username                = "oracleUser"
  password                = "Oracle123"
  license_model           = "bring-your-own-license"
  db_subnet_group_name    = aws_db_subnet_group.default.name  # Add the db_subnet_group_name attribute
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]  # Add the vpc_security_group_ids attribute
  tags                    = {
    Name = "MyRDSInstance"
  }
}

output "rds_instance_endpoint" {
  value = module.rds.rds_instance_endpoint
}

output "rds_instance_id" {
  value = module.rds.rds_instance_id
}

module "alb" {
  source                 = "./modules/load-balancer"
  region                 = "us-west-2"
  alb_name               = "awsLoadBalancerTerraform"
  target_type            = "ip"
  alb_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_ids             = var.subnet_ids
  target_group_name      = "tg-terraform"
  target_group_port      = 80
  vpc_id                 = var.vpc_id
}
