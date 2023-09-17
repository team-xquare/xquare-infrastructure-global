output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "iam_role_arn" {
  value = module.eks.eks_managed_node_groups["initial"].iam_role_arn
}

output "cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}

output "cluster_auth_token" {
  value = data.aws_eks_cluster_auth.cluster.token
}
