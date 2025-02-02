variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "my-ecs-cluster"
}

variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "task_definition_name" {
  description = "Name of the ECS task definition"
  type        = string
  default     = "my-app-task"
}

variable "execution_role_arn" {
  description = "Execution role ARN for ECS tasks"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN for ECS tasks"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN do segredo armazenado no AWS Secrets Manager"
  type        = string
}

variable "db_container_name" {
  description = "Name of the db container in the ECS task"
  type        = string
  default     = "db-container"
}

variable "app_container_name" {
  description = "Name of the app container in the ECS task"
  type        = string
  default     = "app-container"
}

variable "container_memory" {
  description = "Memory in MB allocated for the container"
  type        = number
  default     = 2048
}

variable "container_cpu" {
  description = "CPU units allocated for the container"
  type        = number
  default     = 1024
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "my-ecs-service"
}

variable "desired_count" {
  description = "Number of ECS tasks to run in the service"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS tasks"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for SG"
  type = string
}

variable "allowed_ips" {
  description = "List of allowed IPs for ECS tasks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "task_cpu" {
  description = "CPU allocation for the ECS Task"
  type        = string
  default     = "256"  
}

variable "task_memory" {
  description = "Memory allocation for the ECS Task"
  type        = string
  default     = "512"  
}

variable "db_instance_endpoint" {
  description = "Endpoint of DB instance"
  type = string
}

variable "image_url_backend" {
  description = "URL da imagem Docker do backend no ECR"
  type        = string
}

variable "image_url_populate" {
  description = "URL da imagem Docker do populate no ECR"
  type        = string
}