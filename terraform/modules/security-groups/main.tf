#############################################
# ALB SECURITY GROUP
#############################################

resource "aws_security_group" "alb_sg" {
  name        = "gaurav-task11-alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = var.vpc_id

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "gaurav-task11-alb-sg"
    Project = "gaurav-task11"
  }
}

#############################################
# ECS SECURITY GROUP
#############################################

resource "aws_security_group" "ecs_sg" {
  name        = "gaurav-task11-ecs-sg"
  description = "Allow traffic from ALB to ECS"
  vpc_id      = var.vpc_id

  # Allow traffic from ALB SG on port 1337
  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "gaurav-task11-ecs-sg"
    Project = "gaurav-task11"
  }
}

#############################################
# RDS SECURITY GROUP
#############################################

resource "aws_security_group" "rds_sg" {
  name        = "gaurav-task11-rds-sg"
  description = "Allow traffic from ECS to RDS"
  vpc_id      = var.vpc_id

  # Allow PostgreSQL from ECS SG
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "gaurav-task11-rds-sg"
    Project = "gaurav-task11"
  }
}