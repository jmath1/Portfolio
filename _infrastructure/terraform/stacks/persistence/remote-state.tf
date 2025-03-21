data "terraform_remote_state" "network" {
    backend = "s3"
    config = {
        bucket = "jonathanmathcom-terraform-state"
        key    = "network.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "service" {
    backend = "s3"
    config = {
        bucket = "jonathanmathcom-terraform-state"
        key    = "service.tfstate"
        region = "us-east-1"
    }
}