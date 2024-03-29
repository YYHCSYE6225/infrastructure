resource "aws_route53_record" "dev-record" {
  zone_id = var.dev_domain_id
  name    = ""
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2_instance.public_ip]
}

resource "aws_route53_record" "prod-record" {
  zone_id = var.prod_domain_id
  name    = ""
  type    = "A"
  alias {
    name                   = aws_lb.application_load_balancer.dns_name
    zone_id                = aws_lb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}