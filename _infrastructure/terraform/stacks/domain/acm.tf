resource "aws_acm_certificate" "api_cert" {
  domain_name       = "api.${var.domain_name}.${var.tld}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.main_zone.zone_id
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = 60
}

resource "aws_acm_certificate" "main_cert" {
  domain_name       = "${var.domain_name}.${var.tld}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "main_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.main_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.main_zone.zone_id
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = 60
}

resource "aws_acm_certificate" "metrics_cert" {
  domain_name       = "metrics.${var.domain_name}.${var.tld}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "metrics_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.metrics_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.main_zone.zone_id
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = 60
}
