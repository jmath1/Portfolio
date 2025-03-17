resource "aws_acm_certificate" "_" {
  domain_name       = "${var.name}.com"
  validation_method = "DNS"
}