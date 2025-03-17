data "terraform_remote_state" "service" {
  backend = "s3"

  config = {
    key    = "service.tfstate"
    region = "us-east-1"
    bucket = "jonathanmathcom-terraform-state"
  }
}

data "terraform_remote_state" "ci" {
  backend = "s3"

  config = {
    key    = "ci.tfstate"
    region = "us-east-1"
    bucket = "jonathanmathcom-terraform-state"
  }
}

