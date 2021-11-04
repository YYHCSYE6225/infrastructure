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
  ttl     = "300"
  records = [aws_instance.ec2_instance.public_ip]
}