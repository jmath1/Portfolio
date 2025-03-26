output "acm_cert_arn" {
  value = aws_acm_certificate.api_cert.arn
}

output "acm_cert_status" {
  value = aws_acm_certificate.api_cert.status
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