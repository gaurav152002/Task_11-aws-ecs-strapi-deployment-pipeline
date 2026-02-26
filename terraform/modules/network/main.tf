#############################################
# Create VPC
#############################################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr        # Main VPC CIDR block

  tags = {
    Name = "gaurav-task11-vpc"
    Project = "gaurav-task11"
  }
}

#############################################
# Internet Gateway (for public internet access)
#############################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "gaurav-task11-igw"
    Project = "gaurav-task11"
  }
}

#############################################
# Public Subnet 1
#############################################

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true    # Auto assign public IP

  tags = {
    Name = "gaurav-task11-public-1"
    Project = "gaurav-task11"
  }
}

#############################################
# Public Subnet 2
#############################################

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "gaurav-task11-public-2"
    Project = "gaurav-task11"
  }
}

#############################################
# Private Subnet 1
#############################################

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "gaurav-task11-private-1"
    Project = "gaurav-task11"
  }
}

#############################################
# Private Subnet 2
#############################################

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "gaurav-task11-private-2"
    Project = "gaurav-task11"
  }
}

#############################################
# Route table for Public Subnets
#############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  # Route all traffic to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "gaurav-task11-public-rt"
    Project = "gaurav-task11"
  }
}

#############################################
# Associate public subnets with route table
#############################################

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

#############################################
# SECURITY GROUPS
#############################################

# ALB Security Group (Allow HTTP from internet)

resource "aws_security_group" "alb_sg" {
  name   = "gaurav-task11-alb-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Public access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gaurav-task11-alb-sg"
    Project = "gaurav-task11"
  }
}

# ECS Security Group (Allow traffic only from ALB)

resource "aws_security_group" "ecs_sg" {
  name   = "gaurav-task11-ecs-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # Only ALB allowed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gaurav-task11-ecs-sg"
    Project = "gaurav-task11"
  }
}

# RDS Security Group (Allow Postgres from ECS only)

resource "aws_security_group" "rds_sg" {
  name   = "gaurav-task11-rds-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gaurav-task11-rds-sg"
    Project = "gaurav-task11"
  }
}