locals {
    ssh_key_name = "github_id_rsa"
    hosted_zone_id = data.terraform_remote_state.domain.outputs.route53_zone.id
    alb_subnets = slice(data.aws_subnets.default_subnets.ids, 0, 2)
    ecr_repository_url = data.terraform_remote_state.registry.outputs.registry_url
    ecr_repository_arn = data.terraform_remote_state.registry.outputs.registry_arn
}