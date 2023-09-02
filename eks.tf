locals {
  cluster_version = "1.27"
}

module "eks" {
  source = "./modules/eks-cluster"

  name_prefix     = local.name_prefix
  cluster_version = local.cluster_version

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  public_subnets  = module.vpc.public_subnet_ids
}

output "cluster_id" {
  value = module.eks.cluster_id
}
