resource "aws_secretsmanager_secret" "env_secrets" {
  for_each = local.env_vars
  name     = "${each.key}"
}

resource "aws_secretsmanager_secret_version" "env_secrets_version" {
  for_each    = aws_secretsmanager_secret.env_secrets
  secret_id   = each.value.id
  secret_string = local.env_vars[each.key]
}

resource "aws_secretsmanager_secret" "rds_hostname" {
    name = "rds_hostname"
}

resource "aws_secretsmanager_secret_version" "rds_hostname_version" {
    secret_id   = aws_secretsmanager_secret.rds_hostname.id
    secret_string = aws_db_instance.portfolio_db.endpoint
}