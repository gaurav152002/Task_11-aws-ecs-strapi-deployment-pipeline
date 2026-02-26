#############################################
# Private Subnet IDs
#############################################

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for RDS"
}

#############################################
# RDS Security Group
#############################################

variable "rds_sg_id" {
  type        = string
  description = "Security group for RDS"
}