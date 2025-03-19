resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../../inventory.ini"
  content  = <<-EOT
  [portfolio]
  ${aws_instance.portfolio.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=_infrastructure/terraform/stacks/service/${local.ssh_key_name}
  EOT

  lifecycle {
    replace_triggered_by = [
      aws_instance.portfolio.public_ip,
      local_file.private_key
    ]
  }
}