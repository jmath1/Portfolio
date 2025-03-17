resource "aws_key_pair" "existing_ssh_key" {
  key_name   = "portfolio-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
