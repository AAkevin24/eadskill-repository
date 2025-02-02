resource "aws_db_instance" "postgresql" {
  identifier                = var.db_instance_name
  engine                    = "postgres"
  engine_version            = "13.18"
  instance_class            = var.db_instance_class
  allocated_storage         = var.db_allocated_storage
  db_name                   = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  multi_az                  = var.multi_az 
  skip_final_snapshot       = true
  backup_retention_period   = var.backup_retention_days

  tags = {
    Name = "postgres-db-instance"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = var.db_subnet_group_name
  description = "Subnet group for RDS instance"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id      = var.vpc_id
  name        = "rds-security-group"
  description = "Security group for RDS instance"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}