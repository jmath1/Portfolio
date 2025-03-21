module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.domain_name}-vpc"
  cidr = var.vpc_cidr

  azs                          = local.azs
  public_subnets               = local.public_subnet_cidrs
  private_subnets              = local.private_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

}