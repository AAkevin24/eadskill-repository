output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.app_task.arn
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app_service.name
}

output "cluster_id"{
  description = "value"
  value = aws_ecs_cluster.main.id
}
