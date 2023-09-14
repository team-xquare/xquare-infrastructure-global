locals {
  cluster_version = "1.27"
  node_type       = "m5a.large"
  capacity_type   = "SPOT"
}

module "eksv2" {
  source                 = "./modules/eks-cluster-v2"

  name_prefix     = local.name_prefix_v2
  cluster_version = local.cluster_version
  instance_type   = local.node_type
  capacity_type   = local.capacity_type

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids

  nodegroup_min_size     = 3
  nodegroup_max_size     = 10
  nodegroup_desired_size = 5

  bootstrap_extra_args = "--use-max-pods false --kubelet-extra-args '--max-pods=110'"
  pre_bootstrap_user_data = <<-EOT
    export ENABLE_PREFIX_DELEGATION=true
  EOT
}

output "cluster_id" {
  value = module.eksv2.cluster_id
}
