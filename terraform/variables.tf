#VARIABLES FROM VPC MODULE
variable "vpc_name" {
  description = "VPC name"
  type        = string
  default = "ead-skill-vpc"
}

variable "public_subnet_cidrs" {
  description = "List of CIDRS for public subnets"
  type        = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

#VARIABLES FROM RDS MODULE
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

#VARIABLES FROM LOAD BALANCE MODULE
variable "lb_name" {
  description = "Name of the Load Balancer"
  type        = string
  default     = "ead-skill-load-balance"
}

variable "target_group_name" {
  description = "Name of the target group for the Load Balancer"
  type        = string
  default     = "ead-skill-target-group"
}

#VARIABLES FROM ROUTE53
variable "zone_name" {
  description = "The name of the Route 53 hosted zone"
  type        = string
  default = "eadskill.com."
}

variable "record_name" {
  description = "The name of the record"
  type        = string
  default = "kevin.eadskill.com"
}

#VARIABLES FROM ECS

variable "image_url_backend" {
  description = "URL da imagem Docker do backend no ECR"
  type        = string
}

variable "image_url_populate" {
  description = "URL da imagem Docker do populate no ECR"
  type        = string
}