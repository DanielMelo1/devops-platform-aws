output "terraform_state_bucket" {
  description = "Nome do bucket S3 que armazena o estado remoto"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "terraform_lock_table" {
  description = "Nome da tabela DynamoDB usada para lock de estado"
  value       = aws_dynamodb_table.terraform_lock.name
}
