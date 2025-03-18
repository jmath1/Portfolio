resource "aws_route53_record" "api_dns" {
  zone_id = local.hosted_zone_id
  name    = "api.${var.domain_name}.${var.tld}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.portfolio.public_ip]
}