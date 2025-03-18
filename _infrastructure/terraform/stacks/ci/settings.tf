terraform {
  backend "s3" {
    bucket = "jonathanmathcom-terraform-state"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}

provider "github" {
  token = var.github_token
}
