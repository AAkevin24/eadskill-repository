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

variable "load_balancer_dns_name" {
  description = "DNS name of the Load Balancer (to create the CNAME record)"
  type        = string
}
