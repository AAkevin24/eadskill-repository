resource "aws_route53_zone" "main" {
  name  = var.zone_name

  tags = {
    Name = var.zone_name
  }
}

resource "aws_route53_record" "load_balancer_cname" {
  zone_id = aws_route53_zone.main.id
  name    = var.record_name
  type    = "CNAME"
  ttl     = 60
  records = [var.load_balancer_dns_name]
}
