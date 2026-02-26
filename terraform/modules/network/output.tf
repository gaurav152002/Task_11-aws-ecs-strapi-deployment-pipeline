#############################################
# VPC ID
#############################################

output "vpc_id" {
  value = aws_vpc.this.id
}

#############################################
# Public Subnets
#############################################

output "public_subnet_ids" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

#############################################
# Private Subnets
#############################################

output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

#############################################
# Security Groups
#############################################

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}