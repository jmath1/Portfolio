output "cloudfront_domain" {
  value = aws_cloudfront_distribution.react_app.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.react_app.id
}

output "website_url" {
  value = "https://${aws_cloudfront_distribution.react_app.domain_name}"
}

output "react_app_path" {
  value = var.react_app_path
}