
resource "null_resource" "build_and_deploy" {
  depends_on = [ aws_s3_bucket.react_app, aws_cloudfront_distribution.react_app ]
  triggers = {
    build_dir_hash = local.app_hash
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${var.react_app_path} && \
      npm install && \
      REACT_APP_BACKEND=https://api.${var.domain_name}.${var.tld} REACT_APP_PORTFOLIO_ID=${var.portfolio_id} npm run build && \
      aws s3 sync build/ s3://${aws_s3_bucket.react_app.id}/ --delete
      aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.react_app.id} --paths "/*"

    EOT
  }
}
