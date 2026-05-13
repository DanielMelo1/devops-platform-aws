variable "aws_region" {
  description = "Região AWS onde os recursos do bootstrap serão provisionados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto — usado como prefixo em todos os recursos"
  type        = string
  default     = "devops-platform"
}

variable "environment" {
  description = "Nome do ambiente — bootstrap é executado uma única vez"
  type        = string
  default     = "bootstrap"
}
