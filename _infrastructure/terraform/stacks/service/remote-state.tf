data "terraform_remote_state" "domain" {
  backend = "s3"

  config = {
    key    = "domain.tfstate"
    region = "us-east-1"
    bucket = "jonathanmathcom-terraform-state"
  }
}

data "terraform_remote_state" "registry" {
  backend = "s3"

  config = {
    key    = "registry.tfstate"
    region = "us-east-1"
    bucket = "jonathanmathcom-terraform-state"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    key    = "network.tfstate"
    region = "us-east-1"
    bucket = "jonathanmathcom-terraform-state"
  }
}