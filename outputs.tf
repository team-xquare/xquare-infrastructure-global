output "cluster_id" {
  value = module.eks.cluster_id
}

output "stag_ecr_url" {
  value = {
    for k, v in module.stag_ecr : k => v.ecr_repository_url
  }
}

output "prod_ecr_url" {
  value = {
    for k, v in module.prod_ecr : k => v.ecr_repository_url
  }
}
