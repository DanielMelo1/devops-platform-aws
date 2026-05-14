output "vpc_id" {
  description = "ID da VPC do ambiente prod"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas do ambiente prod"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas do ambiente prod"
  value       = module.network.private_subnet_ids
}

output "vpc_cidr" {
  description = "CIDR block da VPC do ambiente prod"
  value       = module.network.vpc_cidr
}
