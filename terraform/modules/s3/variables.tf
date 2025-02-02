variable "bucket_name" {
  description = "Bucket name for Terraform state"
  type        = string
  default = "tf-state-ead-skill-challenge-kevin"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}