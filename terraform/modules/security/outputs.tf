output "eks_cluster_sg_id" {
  description = "ID do Security Group do EKS control plane"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_sg_id" {
  description = "ID do Security Group dos nodes do EKS"
  value       = aws_security_group.eks_nodes.id
}

output "eks_cluster_role_arn" {
  description = "ARN da IAM role do cluster EKS"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_nodes_role_arn" {
  description = "ARN da IAM role dos nodes do EKS"
  value       = aws_iam_role.eks_nodes.arn
}

output "app_role_arn" {
  description = "ARN da IAM role dos pods da aplicacao — usada pelo IRSA"
  value       = aws_iam_role.app.arn
}

output "oidc_provider_arn" {
  description = "ARN do OIDC Provider — usada pelo IRSA"
  value       = aws_iam_openid_connect_provider.eks.arn
}
