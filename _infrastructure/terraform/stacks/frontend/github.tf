resource "github_actions_secret" "cf_alowed_host" {
  repository      = var.github_repository_repo
  secret_name     = "CLOUDFRONT_ALLOWED_HOST"
  plaintext_value = aws_cloudfront_distribution.react_app.domain_name
}
