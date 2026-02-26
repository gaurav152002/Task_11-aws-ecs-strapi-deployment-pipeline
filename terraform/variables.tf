#############################################
# AWS Region
#############################################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

#############################################
# VPC CIDR
#############################################

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

#############################################
# Public Subnets
#############################################

variable "public_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

#############################################
# Private Subnets
#############################################

variable "private_subnet_1_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  type    = string
  default = "10.0.4.0/24"
}