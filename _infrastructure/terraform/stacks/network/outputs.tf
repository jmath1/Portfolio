output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnet_cidrs" {
  value = local.private_subnet_cidrs
}

output "public_subnet_cidrs" {
  value = local.public_subnet_cidrs
}

output "database_subnet_cidrs" {
  value = local.database_subnet_cidrs
}

output "database_subnet_ids" {
  value = module.vpc.database_subnets
}

output "public_subnets" {
  value = local.public_subnets
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group
}

output "security_group_id" {
  value = module.vpc.default_security_group_id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

