terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# VPC principal do projeto — isolamento completo de rede
resource "aws_vpc" "main" {
  #checkov:skip=CKV2_AWS_11:Flow logs implementados no M5 — módulo de observabilidade
  #checkov:skip=CKV2_AWS_12:Default SG gerenciado no módulo security

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}
