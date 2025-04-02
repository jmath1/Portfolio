data "terraform_remote_state" "web" {
    backend = "s3"
    config = {
        bucket = "jonathanmathcom-terraform-state"
        key    = "web.tfstate"
        region = "us-east-1"
    }
}