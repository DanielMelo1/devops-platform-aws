variable "project_name" {
  description = "Nome do projeto — usado como prefixo em todos os recursos"
  type        = string
  default     = "devops-platform"
}

variable "environment" {
  description = "Nome do ambiente — dev ou prod"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o RDS será provisionado"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas para o subnet group do RDS"
  type        = list(string)
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

variable "db_password" {
  description = "Senha master — nunca exposta, vem do SSM Parameter Store"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Multi-AZ desligado no dev para reduzir custo, obrigatório no prod"
  type        = bool
  default     = false
}

variable "allowed_cidr_blocks" {
  description = "CIDRs autorizados a conectar no banco — apenas subnets privadas da VPC"
  type        = list(string)
}
