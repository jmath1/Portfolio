locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnet_cidrs   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnet_cidrs  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 3)]
  database_subnet_cidrs = [for k,v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 6)]
  public_subnets = module.vpc.public_subnets
}