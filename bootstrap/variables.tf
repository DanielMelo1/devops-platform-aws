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
