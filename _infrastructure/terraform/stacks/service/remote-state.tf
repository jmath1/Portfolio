data "terraform_remote_state" "domain" {
  backend = "s3"

  config = {
    key    = "domain.tfstate"
    region = "us-east-1"
    bucket = "jonathanmathcom-terraform-state"
  }
}
