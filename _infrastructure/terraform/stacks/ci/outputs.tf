output "github_runner_role_arn" {
  value = aws_iam_role.github_runner_role.arn
}

output "github_runner_role_name" {
  value = aws_iam_role.github_runner_role.name
}