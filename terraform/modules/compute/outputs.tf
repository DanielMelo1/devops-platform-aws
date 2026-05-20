output "cluster_name" {
  description = "Nome do cluster EKS — usado pelo kubectl e Helm"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint da API do Kubernetes — usado pelo kubectl"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "Certificado CA do cluster — autenticacao do kubectl"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_version" {
  description = "Versao do Kubernetes em execucao no cluster"
  value       = aws_eks_cluster.main.version
}

output "app_role_arn" {
  description = "ARN da IAM role dos pods da aplicacao — usada pelo IRSA"
  value       = aws_iam_role.app.arn
}

output "oidc_provider_arn" {
  description = "ARN do OIDC Provider — usada pelo IRSA"
  value       = aws_iam_openid_connect_provider.eks.arn
}
