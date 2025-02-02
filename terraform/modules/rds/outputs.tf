output "db_instance_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.postgresql.endpoint
}

output "db_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.postgresql.id
}

output "db_instance_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.postgresql.port
}