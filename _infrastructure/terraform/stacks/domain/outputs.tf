output "acm_api_cert_arn" {
  value = var.use_vpc ? aws_acm_certificate.api_cert[0].arn : null
}

output "acm_cert_status" {
  value = var.use_vpc ? aws_acm_certificate.api_cert[0].status : null
}

output "acm_main_cert_arn" {
  value = aws_acm_certificate.main_cert.arn
}

output "route53_zone" {
  value = aws_route53_zone.main_zone
}

output "metrics_cert_arn" {
  value = aws_acm_certificate.metrics_cert.arn
}

output "metrics_cert_status" {
  value = aws_acm_certificate.metrics_cert.status
}