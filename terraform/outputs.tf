#############################################
# ALB DNS Name (Access your Strapi here)
#############################################

output "alb_dns_name" {
  description = "Public URL of the Load Balancer"
  value       = module.alb.alb_dns_name
}

#############################################
# ECS Cluster Name
#############################################

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

#############################################
# ECS Service Name
#############################################

output "ecs_service_name" {
  value = module.ecs.service_name
}

#############################################
# RDS Endpoint
#############################################

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}