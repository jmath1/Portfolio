
resource "null_resource" "build_and_deploy" {
  triggers = {
    build_dir_hash = sha1(
      join("", 
        [for f in fileset("${var.react_app_path}/build", "**"): filesha1("${var.react_app_path}/build/${f}")]
      )
    )
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${var.react_app_path} && \
      npm install && \
      REACT_APP_BACKEND=https://api.${var.domain_name}.${var.tld} REACT_APP_PORTFOLIO_ID=${var.portfolio_id} npm run build && \
      aws s3 sync build/ s3://${aws_s3_bucket.react_app.id}/ --delete
    EOT
  }
}
