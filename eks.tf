locals {
  cluster_version = "1.27"
  node_type       = "m5a.large"
  capacity_type   = "SPOT"
}

data "aws_caller_identity" "current" {}

module "eksv2" {
  source                 = "./modules/eks-cluster-v2"

  name_prefix     = local.name_prefix_v2
  cluster_version = local.cluster_version
  instance_type   = local.node_type
  capacity_type   = local.capacity_type

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  nodegroup_min_size     = 1
  nodegroup_max_size     = 1
  nodegroup_desired_size = 1

  bootstrap_extra_args = "--use-max-pods false --kubelet-extra-args '--max-pods=110'"
  pre_bootstrap_user_data = <<-EOT
    export ENABLE_PREFIX_DELEGATION=true
  EOT

  auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/xquare"
      username = "xquare-admin"
      groups   = ["system:masters"]
    }
  ]
  auth_roles = [
    {
      rolearn  = module.karpenter.irsa_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]
}

output "cluster_id" {
  value = module.eksv2.cluster_id
}
