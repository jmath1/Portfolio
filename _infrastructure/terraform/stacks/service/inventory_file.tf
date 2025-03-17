resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../../inventory.ini"
  content  = <<-EOT
  [portfolio]
  ${aws_instance.portfolio.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
  EOT
}