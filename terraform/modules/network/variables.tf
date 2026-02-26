#############################################
# VPC CIDR
#############################################

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

#############################################
# Public Subnet CIDRs
#############################################

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

#############################################
# Private Subnet CIDRs
#############################################

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}