output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.ead_skill.id
}

output "public_subnet_ids" {
  description = "Subnets public IDs"
  value       = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

output "private_subnet_ids" {
  description = "Subnets private IDs"
  value       = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}

output "availability_zones" {
  description = "Zonas de disponibilidade"
  value       = var.availability_zones
}
