output "vpc_id" {
  description = "ID da VPC do ambiente dev"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas do ambiente dev"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas do ambiente dev"
  value       = module.network.private_subnet_ids
}

output "vpc_cidr" {
  description = "CIDR block da VPC do ambiente dev"
  value       = module.network.vpc_cidr
}

output "db_endpoint" {
  description = "Endpoint de conexão do RDS do ambiente dev"
  value       = module.database.db_endpoint
}

output "db_port" {
  description = "Porta do PostgreSQL"
  value       = module.database.db_port
}

output "db_name" {
  description = "Nome do banco de dados criado no ambiente dev"
  value       = module.database.db_name
}
