#############################################
# ECS Cluster Name
#############################################

output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

#############################################
# ECS Service Name
#############################################

output "service_name" {
  value = aws_ecs_service.this.name
}