variable "ecs_execution_role_name" {
  description = "Role name fron execution ECS"
  type        = string
  default     = "ecs_execution_role"
}

variable "ecs_task_role_name" {
  description = "Role name from task ECS"
  type        = string
  default     = "ecs_task_role"
}

variable "assume_role_policy" {
  description = "Police from ECS assume role"
  type        = string
  default     = "ecs-tasks.amazonaws.com"
}

variable "role_policies" {
  description = "Policies list to attach an a role task"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AmazonECSTaskExecutionRolePolicy"]
}

variable "secret_arn" {
  type        = string
  description = "ARN do segredo no Secrets Manager"
}