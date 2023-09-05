locals {
  cluster_version = "1.27"
  node_type       = "m5a.large"
  capacity_type   = "SPOT"
}

module "eks" {
  source = "./modules/eks-cluster"

  name_prefix     = local.name_prefix
  cluster_version = local.cluster_version
  instance_type   = local.node_type
  capacity_type   = local.capacity_type

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  public_subnets  = module.vpc.public_subnet_ids

  nodegroup_min_size     = 3
  nodegroup_max_size     = 6
  nodegroup_desired_size = 5
}

output "cluster_id" {
  value = module.eks.cluster_id
}

/*module "eksv2" {
  source                 = "./modules/eks-cluster-v2"

  name_prefix     = local.name_prefix_v2
  cluster_version = local.cluster_version
  instance_type   = local.node_type
  capacity_type   = local.capacity_type

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids

  nodegroup_min_size     = 3
  nodegroup_max_size     = 6
  nodegroup_desired_size = 5
}*/
