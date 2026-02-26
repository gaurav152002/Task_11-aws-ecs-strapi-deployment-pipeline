#############################################
# CodeDeploy App Name
#############################################

output "codedeploy_app_name" {
  value = aws_codedeploy_app.ecs.name
}

#############################################
# Deployment Group Name
#############################################

output "codedeploy_deployment_group" {
  value = aws_codedeploy_deployment_group.ecs.deployment_group_name
}