output "secrets_arns" {
    value = concat(
        [for secret in aws_secretsmanager_secret.env_secrets : secret.arn],
        [aws_secretsmanager_secret.rds_hostname.arn],
        [aws_secretsmanager_secret.allowed_host.arn],
        [aws_secretsmanager_secret.rds_port.arn]
    )
}