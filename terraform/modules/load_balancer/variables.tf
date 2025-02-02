variable "lb_name" {
  description = "Name of the Load Balancer"
  type        = string
  default     = "ead-skill-load-balance"
}

variable "subnet_ids" {
  description = "List of subnet IDs where the Load Balancer should be deployed"
  type        = list(string)
}

variable "allowed_ips" {
  description = "List of allowed IPs to access the Load Balancer"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vpc_id" {
  description = "VPC ID where the Load Balancer will be created"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group for the Load Balancer"
  type        = string
  default     = "ead-skill-target-group"
}
