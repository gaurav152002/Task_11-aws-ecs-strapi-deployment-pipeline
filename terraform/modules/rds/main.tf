#############################################
# RDS Subnet Group
#############################################

resource "aws_db_subnet_group" "this" {
  name       = "gaurav-task11-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = "gaurav-task11-db-subnet-group"
    Project = "gaurav-task11"
  }
}

#############################################
# PostgreSQL RDS Instance
#############################################

resource "aws_db_instance" "this" {
  identifier              = "gaurav-task11-postgres"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name     = var.db_name
  username    = var.db_username
  password    = var.db_password

  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]

  tags = {
    Name    = "gaurav-task11-rds"
    Project = "gaurav-task11"
  }
}