#############################################
# Public Subnets
#############################################

variable "public_subnet_ids" {
  type = list(string)
}

#############################################
# ECS Security Group
#############################################

variable "ecs_sg_id" {
  type = string
}

#############################################
# RDS Endpoint
#############################################

variable "rds_endpoint" {
  type = string
}

#############################################
# Blue Target Group ARN
#############################################

variable "blue_tg_arn" {
  type = string
}

#############################################
# Initial ECR Image URL
#############################################

variable "ecr_image_url" {
  type        = string
  description = "Initial image URL (latest)"
}