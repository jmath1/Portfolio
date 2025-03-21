locals {
  env_vars = {
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    DB_NAME     = var.db_name
    SECRET_KEY  = var.secret_key
  }

  database_subnet_ids = data.terraform_remote_state.network.outputs.database_subnet_ids
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_cidrs = data.terraform_remote_state.network.outputs.public_subnet_cidrs
  ec2_sg_id = data.terraform_remote_state.service.outputs.ec2_security_group_id
}
