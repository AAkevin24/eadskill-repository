output "secret_arn" {
  description = "ARN do segredo armazenado no AWS Secrets Manager"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "secret_name" {
  description = "Nome do segredo armazenado"
  value       = aws_secretsmanager_secret.db_credentials.name
}
