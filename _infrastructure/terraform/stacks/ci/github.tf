resource "github_actions_secret" "ecr_uri" {
  repository      = var.github_repository_repo
  secret_name     = "ECR_URI"
  plaintext_value = data.terraform_remote_state.registry.outputs.registry_url
}

resource "github_actions_secret" "aws_account_number" {
  repository      = var.github_repository_repo
  secret_name     = "AWS_ACCOUNT_NUMBER"
  plaintext_value = var.aws_account_number
}

resource "github_actions_secret" "public_ip" {
  repository      = var.github_repository_repo
  secret_name     = "PUBLIC_IP"
  plaintext_value = data.terraform_remote_state.web.outputs.ec2_public_ip
}