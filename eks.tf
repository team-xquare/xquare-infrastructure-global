locals {
  cluster_version = "1.27"
  node_type       = "m5a.large"
  capacity_type   = "SPOT"
}

module "eksv2" {
  source                 = "./modules/eks-cluster-v2"

  name_prefix     = local.name_prefix_v2
  cluster_version = local.cluster_version

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
}

output "cluster_id" {
  value = module.eksv2.cluster_id
}
