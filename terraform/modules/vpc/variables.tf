variable "cidr_block" {
  description = "CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default = "ead-skill-vpc"
}

variable "public_subnet_cidrs" {
  description = "List of CIDRS for public subnets"
  type        = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
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