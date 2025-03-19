locals {
  github_runner_role_name = aws_iam_role.github_runner_role.name
  github_runner_role_arn = aws_iam_role.github_runner_role.arn
  ecr_repo_arn = data.terraform_remote_state.registry.outputs.registry_arn
}