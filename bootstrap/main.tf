terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# us-east-1 definida como região principal — menor custo e maior disponibilidade de serviços
provider "aws" {
  region = var.aws_region
}
