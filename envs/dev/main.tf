terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Chama o módulo de rede passando os valores do ambiente dev
module "network" {
  source = "../../terraform/modules/network"

  project_name    = var.project_name
  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "database" {
  source = "../../terraform/modules/database"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance_class  = var.db_instance_class
  db_engine_version  = var.db_engine_version
  multi_az           = var.multi_az
  allowed_cidr_blocks = [module.network.vpc_cidr]
}

module "security" {
  source = "../../terraform/modules/security"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  vpc_cidr         = module.network.vpc_cidr
}


module "compute" {
  source = "../../terraform/modules/compute"

  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.network.private_subnet_ids
  eks_cluster_sg_id  = module.security.eks_cluster_sg_id
  cluster_role_arn   = module.security.eks_cluster_role_arn
  nodes_role_arn     = module.security.eks_nodes_role_arn
  eks_version        = var.eks_version
  node_instance_type = var.node_instance_type
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
}

module "monitoring" {
  source = "../../terraform/modules/monitoring"

  project_name     = var.project_name
  environment      = var.environment
  eks_cluster_name = "${var.project_name}-${var.environment}"
  rds_instance_id  = "${var.project_name}-${var.environment}"
  alarm_email      = var.alarm_email
  oidc_provider_id = "DE9661147C47439875DBD47BB29954FE"
}
