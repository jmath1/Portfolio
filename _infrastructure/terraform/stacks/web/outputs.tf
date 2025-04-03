output "secrets_arns" {
    value = concat(
        [for secret in aws_secretsmanager_secret.env_secrets : secret.arn],
        [aws_secretsmanager_secret.rds_hostname.arn],
        [aws_secretsmanager_secret.allowed_host.arn],
        [aws_secretsmanager_secret.rds_port.arn]
    )
}


output "ec2_public_ip" {
  value = aws_instance.portfolio.public_ip
}

output "ec2_instance_profile" {
  value = aws_instance.portfolio.iam_instance_profile
}

output "ec2_role_name" {
  value = aws_iam_role.portfolio_role.name
}

output "ec2_role_arn" {
  value = aws_iam_role.portfolio_role.arn
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "rds_security_group_id" {
  value       = var.use_rds ? aws_security_group.rds_sg[0].id : null
}

output "ec2_instance_id" {
  value = aws_instance.portfolio.id
}

output "rds_instance_identifier" {
  value = var.use_rds ? aws_db_instance.portfolio_db[0].identifier : null
}