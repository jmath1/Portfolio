locals {
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnet_cidrs   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnet_cidrs  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 3)]
  public_subnets = module.vpc.public_subnets
}