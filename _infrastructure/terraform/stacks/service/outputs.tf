output "ec2_public_ip" {
  value = aws_instance.portfolio.public_ip
}

output "ec2_instance_profile" {
  value = aws_instance.portfolio.iam_instance_profile
}

output "ec2_role_name" {
  value = aws_iam_role.portfolio_role.name
}