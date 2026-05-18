terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Controla acesso ao RDS - apenas subnets privadas da VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL - acesso restrito as subnets privadas da VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Saida liberada - necessario para o banco responder as queries"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #checkov:skip=CKV_AWS_382: Egress irrestrito necessario para RDS responder as queries
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-${var.environment}"
  engine            = "postgres"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = var.multi_az #checkov:skip=CKV_AWS_157: Multi-AZ desabilitado no dev - habilitado no prod via variavel
  publicly_accessible = false

  storage_encrypted          = true
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  # Snapshot desabilitado - destruicao limpa em ambiente de estudo
  skip_final_snapshot = true

  # Backup minimo no dev - obrigatorio no prod
  backup_retention_period = 7

  #checkov:skip=CKV_AWS_293: Deletion protection desabilitado - permite terraform destroy em ambiente de estudo
  #checkov:skip=CKV_AWS_161: IAM authentication implementado no M3 - modulo security e IRSA
  #checkov:skip=CKV_AWS_129: Logs do RDS implementados no M5 - modulo observabilidade
  #checkov:skip=CKV_AWS_118: Enhanced monitoring implementado no M5 - modulo observabilidade
  #checkov:skip=CKV_AWS_353: Performance insights implementado no M5 - modulo observabilidade
  #checkov:skip=CKV2_AWS_30: Query logging implementado no M5 - modulo observabilidade
  #checkov:skip=CKV2_AWS_60: Copy tags implementado - corrigido nesta versao

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds"
    Environment = var.environment
  }
}
