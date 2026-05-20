terraform {
  required_version = ">= 1.5.0"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}"
  version  = var.eks_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [var.eks_cluster_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true #checkov:skip=CKV_AWS_38: Endpoint acessivel de 0.0.0.0/0 — necessario para kubectl do WSL2 — restringir em producao
    #checkov:skip=CKV_AWS_39: Endpoint publico habilitado para kubectl do WSL2 — desabilitar em producao com VPN
  }

  #checkov:skip=CKV_AWS_58: Secrets encryption via KMS fora do escopo — custo adicional sem beneficio proporcional no dev
  #checkov:skip=CKV_AWS_37: Control plane logging implementado no M5 — modulo observabilidade

  tags = {
    Name        = "${var.project_name}-${var.environment}-eks"
    Environment = var.environment
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-${var.environment}-nodes"
  node_role_arn   = var.nodes_role_arn
  subnet_ids      = var.private_subnet_ids

  instance_types = [var.node_instance_type]

  remote_access {
    ec2_ssh_key = null #checkov:skip=CKV_AWS_100: SSH desabilitado — ec2_ssh_key null — acesso via kubectl exec
  }

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    # Maximo de nodes indisponiveis durante update — zero downtime
    max_unavailable = 1
  }

  depends_on = [aws_eks_cluster.main]

  tags = {
    Name        = "${var.project_name}-${var.environment}-nodes"
    Environment = var.environment
  }
}
