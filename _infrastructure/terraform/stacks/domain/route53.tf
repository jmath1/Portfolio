resource "aws_route53_zone" "main_zone" {
  name         = "${var.domain_name}.${var.tld}"
}

resource "aws_route53domains_registered_domain" "domain" {
  domain_name = "${var.domain_name}.${var.tld}"

  name_server {
    name = aws_route53_zone.main_zone.name_servers[0]
  }

  name_server {
    name = aws_route53_zone.main_zone.name_servers[1]
  }

  name_server {
    name = aws_route53_zone.main_zone.name_servers[2]
  }

  name_server {
    name = aws_route53_zone.main_zone.name_servers[3]
  }
}