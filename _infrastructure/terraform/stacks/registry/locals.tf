locals {
    aws_instance_profile = data.terraform_remote_state.service.outputs.ec2_instance_profile
    ec2_role_name = data.terraform_remote_state.service.outputs.ec2_role_name
    github_oidc_role_arn = data.terraform_remote_state.ci.outputs.github_runner_role_arn
    github_runner_role_name = data.terraform_remote_state.ci.outputs.github_runner_role_name
}