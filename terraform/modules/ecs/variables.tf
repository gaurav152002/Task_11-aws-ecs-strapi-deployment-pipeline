variable "execution_role_arn" {
  type = string
}

variable "ecr_image_url" {
  type = string
}

variable "rds_endpoint" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "blue_tg_arn" {
  type = string
}