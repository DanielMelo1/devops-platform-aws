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
  description = "ID da VPC onde o EKS sera provisionado"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR da VPC — usado nas regras do Security Group"
  type        = string
}
