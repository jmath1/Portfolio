data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    key    = "network.tfstate"
    region = "us-east-1"
    bucket = "jonathanmathcom-terraform-state"
  }
}
