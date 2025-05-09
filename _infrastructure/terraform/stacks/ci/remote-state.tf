data "terraform_remote_state" "registry" {
    backend = "s3"
    config = {
        bucket = "jonathanmathcom-terraform-state"
        key    = "registry.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "web" {
    backend = "s3"
    config = {
        bucket = "jonathanmathcom-terraform-state"
        key    = "web.tfstate"
        region = "us-east-1"
    }
}