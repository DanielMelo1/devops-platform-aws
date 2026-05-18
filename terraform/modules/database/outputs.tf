output "db_endpoint" {
  description = "Endpoint de conexão do RDS — usado pela aplicação via SSM"
  value       = aws_db_instance.main.endpoint
}

output "db_port" {
  description = "Porta do PostgreSQL"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Nome do banco de dados criado"
  value       = aws_db_instance.main.db_name
}

output "rds_security_group_id" {
  description = "ID do Security Group do RDS — referenciado pelo módulo compute no M3"
  value       = aws_security_group.rds.id
}
