output "vpc_id" {
  description = "ID da VPC principal"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas — usadas pelo ALB"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas — usadas pelo EKS e RDS"
  value       = aws_subnet.private[*].id
}

output "vpc_cidr" {
  description = "CIDR block da VPC — usado nos Security Groups"
  value       = aws_vpc.main.cidr_block
}
