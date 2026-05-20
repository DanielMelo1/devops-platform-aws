variable "project_name" {
  description = "Nome do projeto — usado como prefixo em todos os recursos"
  type        = string
  default     = "devops-platform"
}

variable "environment" {
  description = "Nome do ambiente — dev ou prod"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas — nodes do EKS ficam aqui"
  type        = list(string)
}

variable "eks_cluster_sg_id" {
  description = "ID do Security Group do EKS control plane — vem do modulo security"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN da IAM role do cluster EKS — vem do modulo security"
  type        = string
}

variable "nodes_role_arn" {
  description = "ARN da IAM role dos nodes — vem do modulo security"
  type        = string
}

variable "eks_version" {
  description = "Versao do Kubernetes — verificar versoes suportadas pelo EKS"
  type        = string
  default     = "1.32"
}

variable "node_instance_type" {
  description = "Tipo EC2 dos nodes — t3.medium no dev para reduzir custo"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Numero desejado de nodes em operacao normal"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimo de nodes — HPA escala para baixo ate esse limite"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximo de nodes — HPA escala para cima ate esse limite"
  type        = number
  default     = 4
}
