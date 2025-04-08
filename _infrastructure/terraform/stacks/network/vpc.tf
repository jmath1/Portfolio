module "vpc" {
  count = var.use_vpc ? 1 : 0
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.domain_name}-vpc"
  cidr = var.vpc_cidr

  azs                          = local.azs
  public_subnets               = local.public_subnet_cidrs
  private_subnets              = local.private_subnet_cidrs

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

}