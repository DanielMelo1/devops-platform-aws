# Tabela de lock — impede execuções simultâneas do Terraform
resource "aws_dynamodb_table" "terraform_lock" {
  #checkov:skip=CKV_AWS_119:Criptografia AWS managed key suficiente para tabela de lock — CMK adicionaria custo sem benefício proporcional

  name         = "${var.project_name}-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # PITR ativado — permite recuperar estado corrompido em qualquer ponto das últimas 35 dias
  point_in_time_recovery {
    enabled = true
  }

  # Criptografia com chave gerenciada pela AWS — padrão para dados de infraestrutura
  server_side_encryption {
    enabled = true
  }
}
