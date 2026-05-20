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

output "eks_cluster_name" {
  description = "Nome do cluster EKS — usado pelo kubectl e Helm"
  value       = module.compute.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint da API do Kubernetes"
  value       = module.compute.cluster_endpoint
}

output "eks_cluster_version" {
  description = "Versao do Kubernetes em execucao"
  value       = module.compute.cluster_version
}
