variable "project_name" {
  description = "Nome do projeto — usado como prefixo em todos os recursos"
  type        = string
  default     = "devops-platform"
}

variable "environment" {
  description = "Nome do ambiente — dev ou prod"
  type        = string
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS — usado nos alarmes"
  type        = string
}

variable "rds_instance_id" {
  description = "ID da instancia RDS — usado nos alarmes"
  type        = string
}

variable "alarm_email" {
  description = "Email para receber notificacoes dos alarmes"
  type        = string
}
