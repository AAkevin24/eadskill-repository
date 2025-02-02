output "load_balancer_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_arn" {
  description = "ARN of the Load Balancer"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.target_group.arn
}
