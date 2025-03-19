output "registry_url" {
  value = aws_ecr_repository.portfolio_repo.repository_url
}

output "registry_arn" {
  value = aws_ecr_repository.portfolio_repo.arn
}
