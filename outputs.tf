output "cluster_id" {
  value = module.eks.cluster_id
}

output "stag_ecr_url" {
  value = module.stag_ecr[*].ecr_repository_url
}

output "prod_ecr_url" {
  value = module.prod_ecr[*].ecr_repository_url
}
