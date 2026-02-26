#############################################
# Create VPC
#############################################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name    = "gaurav-task11-vpc"
    Project = "gaurav-task11"
  }
}

#############################################
# Internet Gateway
#############################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "gaurav-task11-igw"
    Project = "gaurav-task11"
  }
}

#############################################
# Public Route Table
#############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  # Route all internet traffic to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name    = "gaurav-task11-public-rt"
    Project = "gaurav-task11"
  }
}

#############################################
# Associate Public Subnet 1
#############################################

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

#############################################
# Associate Public Subnet 2
#############################################

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

#############################################
# Public Subnet 1
#############################################

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "gaurav-task11-public-1"
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
    Name    = "gaurav-task11-public-2"
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
    Name    = "gaurav-task11-private-1"
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
    Name    = "gaurav-task11-private-2"
    Project = "gaurav-task11"
  }
}