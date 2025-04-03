locals {
    ec2_instance_id = data.terraform_remote_state.web.outputs.ec2_instance_id
    rds_instance_identifier = var.use_rds ? data.terraform_remote_state.web.outputs.rds_instance_identifier : null
}