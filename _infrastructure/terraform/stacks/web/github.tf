resource "github_actions_secret" "ssh_pk" {
  repository      = var.github_repository_repo
  secret_name     = "SSH_PK"
  plaintext_value = tls_private_key.ssh_key.private_key_pem
}
