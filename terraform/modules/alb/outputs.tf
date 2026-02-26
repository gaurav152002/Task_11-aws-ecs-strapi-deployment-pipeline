#############################################
# ALB DNS
#############################################

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

#############################################
# Target Group ARNs
#############################################

output "blue_tg_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_tg_arn" {
  value = aws_lb_target_group.green.arn
}

#############################################
# Target Group Names (Needed for CodeDeploy)
#############################################

output "blue_tg_name" {
  value = aws_lb_target_group.blue.name
}

output "green_tg_name" {
  value = aws_lb_target_group.green.name
}

#############################################
# Listener ARN
#############################################

output "listener_arn" {
  value = aws_lb_listener.http.arn
}