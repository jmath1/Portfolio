locals {
  env_vars = {
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    DB_NAME     = var.db_name
    SECRET_KEY  = var.secret_key
  }

  vpc_id = var.use_vpc ? data.terraform_remote_state.network.outputs.vpc_id : ""

  ssh_key_name = "github_id_rsa"
  hosted_zone_id = data.terraform_remote_state.domain.outputs.route53_zone.id
  ecr_repository_url = data.terraform_remote_state.registry.outputs.registry_url
  ecr_repository_arn = data.terraform_remote_state.registry.outputs.registry_arn

  vpc_security_group_id = var.use_vpc ? data.terraform_remote_state.network.outputs.security_group_id : ""
  vpc_cidr = var.use_vpc ? data.terraform_remote_state.network.outputs.vpc_cidr : ""
  
  public_subnets = var.use_vpc ? data.terraform_remote_state.network.outputs.public_subnets : []
  public_subnet_cidrs = var.use_vpc ? data.terraform_remote_state.network.outputs.public_subnet_cidrs : []
  
  private_subnets = var.use_vpc ? data.terraform_remote_state.network.outputs.private_subnets : []
  private_subnet_cidrs = var.use_vpc ? data.terraform_remote_state.network.outputs.private_subnet_cidrs : []
}
