#############################################
# RDS Endpoint
#############################################

output "rds_endpoint" {
  description = "PostgreSQL endpoint"
  value       = aws_db_instance.this.address
}