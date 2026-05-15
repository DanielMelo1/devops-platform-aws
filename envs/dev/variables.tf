variable "aws_region" {
  description = "Região AWS do ambiente dev"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "devops-platform"
}

variable "environment" {
  description = "Nome do ambiente"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block da VPC do ambiente dev"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Zonas de disponibilidade"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "CIDRs das subnets públicas do ambiente dev"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "CIDRs das subnets privadas do ambiente dev"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "db_name" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuário master do banco de dados"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Senha master — nunca exposta, vem do SSM Parameter Store"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe da instância RDS — t3.micro no dev para reduzir custo"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "Versão do PostgreSQL"
  type        = string
  default     = "15.7"
}

variable "multi_az" {
  description = "Multi-AZ desligado no dev para reduzir custo"
  type        = bool
  default     = false
}
