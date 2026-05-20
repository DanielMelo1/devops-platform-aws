terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

resource "aws_security_group" "eks_cluster" {
  name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
  description = "Controla acesso ao EKS control plane"
  vpc_id      = var.vpc_id

  ingress {
    description = "API server - acesso dos nodes ao control plane"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Saida liberada - control plane precisa falar com nodes e AWS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #checkov:skip=CKV_AWS_382: Egress irrestrito necessario - control plane precisa acessar ECR, SSM e nodes
  }

  #checkov:skip=CKV2_AWS_5: SG referenciado pelo modulo compute — Checkov nao detecta ligacao entre modulos

  tags = {
    Name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-${var.environment}-eks-nodes-sg"
  description = "Controla acesso aos nodes do EKS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Comunicacao interna entre nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Control plane para nodes - kubelet e pods"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  egress {
    description = "Saida liberada - nodes precisam acessar ECR, SSM e RDS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #checkov:skip=CKV_AWS_382: Egress irrestrito necessario - nodes precisam acessar ECR, SSM e RDS
  }

  #checkov:skip=CKV2_AWS_5: SG referenciado pelo modulo compute — Checkov nao detecta ligacao entre modulos

  tags = {
    Name        = "${var.project_name}-${var.environment}-eks-nodes-sg"
    Environment = var.environment
  }
}
