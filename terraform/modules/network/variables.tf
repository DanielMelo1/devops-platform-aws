variable "project_name" {
  description = "Nome do projeto — usado como prefixo em todos os recursos"
  type        = string
  default     = "devops-platform"
}

variable "environment" {
  description = "Nome do ambiente — dev ou prod"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR principal da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Zonas de disponibilidade — duas para garantir Multi-AZ"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "CIDRs das subnets públicas — uma por AZ"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "CIDRs das subnets privadas — uma por AZ"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}
