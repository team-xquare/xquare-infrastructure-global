module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = local.vpc_id
  subnet_ids = local.public_subnets

  enable_irsa = true

  cluster_enabled_log_types = []
  create_cloudwatch_log_group = false

  node_security_group_additional_rules = {
    ingress_nodes_karpenter_port = {
      description                   = "Cluster API to Node group for Karpenter webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }

  manage_aws_auth_configmap = true

  aws_auth_users = concat(
    [{
      userarn  = data.aws_caller_identity.current.arn
      username = local.current_username
      groups   = ["system:masters"]
    }],
    var.auth_users
  )
  aws_auth_roles = var.auth_roles

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}
module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = "initial"
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  subnet_ids = local.public_subnets

  instance_types         = [local.instance_type]

  create_launch_template = false
  use_custom_launch_template = false

  min_size     = var.nodegroup_min_size
  max_size     = var.nodegroup_max_size
  desired_size = var.nodegroup_desired_size
  iam_role_additional_policies = {
    additional = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  bootstrap_extra_args = var.bootstrap_extra_args

  enable_bootstrap_user_data = true
  pre_bootstrap_user_data = var.pre_bootstrap_user_data

  taints = {
    dedicated = {
      key    = "xquare/critical-pods"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }
}