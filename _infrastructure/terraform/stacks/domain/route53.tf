resource "aws_route53_zone" "jonathanmath_com" {
  name = "${var.name}.com"
}