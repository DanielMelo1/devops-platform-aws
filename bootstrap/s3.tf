# Bucket para armazenar o estado remoto do Terraform
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-tfstate-${data.aws_caller_identity.current.account_id}"

  # Proteção contra destruição acidental do estado
  lifecycle {
    prevent_destroy = true
  }
}

# Versionamento obrigatório — permite recuperar estado anterior em caso de erro
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Criptografia AES-256 — estado pode conter ARNs e nomes de recursos sensíveis
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloqueia qualquer acesso público — estado da infraestrutura nunca deve ser público
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Recupera o Account ID dinamicamente — evita hardcode do ID da conta
data "aws_caller_identity" "current" {}
