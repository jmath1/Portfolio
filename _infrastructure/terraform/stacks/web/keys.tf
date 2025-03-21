resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${local.ssh_key_name}"
  file_permission = "0600"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "github_actions_secret" "ssh_pk" {
  repository      = var.github_repository_repo
  secret_name     = "SSH_PK"
  plaintext_value = tls_private_key.ssh_key.private_key_pem
}
