# Tabela de lock — impede execuções simultâneas do Terraform
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "${var.project_name}-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"

  # LockID é a chave obrigatória para o mecanismo de lock do Terraform
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
