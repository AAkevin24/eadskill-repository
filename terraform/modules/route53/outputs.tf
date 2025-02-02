output "route53_record_name" {
  description = "Nome do registro CNAME"
  value       = aws_route53_record.load_balancer_cname.name
}

output "route53_record_dns" {
  description = "DNS do Load Balancer configurado"
  value       = aws_route53_record.load_balancer_cname.records
}