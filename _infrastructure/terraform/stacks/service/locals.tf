locals {
    ssh_key_name = "github_id_rsa"
    hosted_zone_id = data.terraform_remote_state.domain.outputs.route53_zone.id
}