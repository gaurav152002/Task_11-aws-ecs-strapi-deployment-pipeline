#############################################
# ECS Cluster Name
#############################################

variable "cluster_name" {
  type = string
}

#############################################
# ECS Service Name
#############################################

variable "service_name" {
  type = string
}

#############################################
# Target Group Names
#############################################

variable "blue_tg_name" {
  type = string
}

variable "green_tg_name" {
  type = string
}

#############################################
# Listener ARN
#############################################

variable "listener_arn" {
  type = string
}