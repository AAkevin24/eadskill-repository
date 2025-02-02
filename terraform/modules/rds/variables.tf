variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = "rds-subnet-group"
}

variable "vpc_id" {
  description = "VPC ID for SG"
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB instance"
  type        = list(string)
}

variable "allowed_ips" {
  description = "List of allowed IPs"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_instance_name" {
  description = "Name of RDS instance"
  type        = string
  default     = "ead-postgres-db"
}

variable "db_instance_class" {
  description = "The class of the RDS instance"
  type        = string
  default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "The allocated storage (in GB) for the RDS instance"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "eadskilldb"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "eadskill"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default = "eadskill"
}

variable "multi_az" {
  description = "RDS instance should be Multi-AZ"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "The number of days to retain backups for the RDS instance"
  type        = number
  default     = 7
}
