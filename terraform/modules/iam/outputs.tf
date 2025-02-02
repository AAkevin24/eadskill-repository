output "execution_role_arn" {
  description = "ARN role from execution ECS"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "task_role_arn" {
  description = "ARN role from ECS task"
  value       = aws_iam_role.ecs_task_role.arn
}
