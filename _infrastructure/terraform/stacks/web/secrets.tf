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
    name = "DB_HOST"
}

resource "aws_secretsmanager_secret_version" "rds_hostname_version" {
    secret_id   = aws_secretsmanager_secret.rds_hostname.id
    secret_string = aws_db_instance.portfolio_db.address
}

resource "aws_secretsmanager_secret" "rds_port" {
    name = "DB_PORT"
}

resource "aws_secretsmanager_secret_version" "rds_port_version" {
    secret_id   = aws_secretsmanager_secret.rds_port.id
    secret_string = aws_db_instance.portfolio_db.port
}

resource "aws_secretsmanager_secret" "allowed_host" {
    name = "ALLOWED_HOST"
}

resource "aws_secretsmanager_secret_version" "alloweed_host_version" {
    secret_id   = aws_secretsmanager_secret.allowed_host.id
    secret_string = "api.${var.domain_name}.${var.tld}"
}

resource "aws_secretsmanager_secret" "bucket_arn" {
    name = "S3_BUCKET_ARN"
}

resource "aws_secretsmanager_secret_version" "bucket_arn_version" {
    secret_id   = aws_secretsmanager_secret.bucket_arn.id
    secret_string = aws_s3_bucket.portfolio_bucket.arn
}

resource "aws_secretsmanager_secret" "private_ec2_ip" {
    name = "PRIVATE_IP"
}

resource "aws_secretsmanager_secret_version" "private_ec2_ip_version" {
    secret_id   = aws_secretsmanager_secret.private_ec2_ip.id
    secret_string = aws_instance.portfolio.private_ip
}