locals {
    ssh_key_name = "github_id_rsa"
    hosted_zone_id = data.terraform_remote_state.domain.outputs.route53_zone.id
    ecr_repository_url = data.terraform_remote_state.registry.outputs.registry_url
    ecr_repository_arn = data.terraform_remote_state.registry.outputs.registry_arn

    vpc_id = data.terraform_remote_state.network.outputs.vpc_id
    vpc_security_group_id = data.terraform_remote_state.network.outputs.security_group_id
    vpc_cidr = data.terraform_remote_state.network.outputs.vpc_cidr
    
    public_subnets = data.terraform_remote_state.network.outputs.public_subnets
    public_subnet_cidrs = data.terraform_remote_state.network.outputs.public_subnet_cidrs
    
    private_subnets = data.terraform_remote_state.network.outputs.private_subnets
    private_subnet_cidrs = data.terraform_remote_state.network.outputs.private_subnet_cidrs
    
    database_subnets = data.terraform_remote_state.network.outputs.database_subnet_ids
    database_subnet_cidrs = data.terraform_remote_state.network.outputs.database_subnet_cidrs
    
}