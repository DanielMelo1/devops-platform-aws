variable "aws_region" {
  description = "Região AWS do ambiente prod"
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
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block da VPC do ambiente prod — separado do dev para evitar conflito em VPC peering"
  type        = string
  default     = "10.1.0.0/16"
}

variable "azs" {
  description = "Zonas de disponibilidade"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "CIDRs das subnets públicas do ambiente prod"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnets" {
  description = "CIDRs das subnets privadas do ambiente prod"
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.11.0/24"]
}
