resource "aws_route53_record" "ec2_dns" {
  count = var.use_vpc ? 0 : 1

  zone_id = data.terraform_remote_state.domain.outputs.route53_zone.id
  name    = "api.${var.domain_name}.${var.tld}"
  type    = "A"

  ttl     = 300
  records = [aws_instance.portfolio.public_ip]

}