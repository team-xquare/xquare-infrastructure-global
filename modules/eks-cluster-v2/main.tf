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

  eks_managed_node_group_defaults = {
    instance_types = [local.instance_type]
    capacity_type  = local.capacity_type
  }
  eks_managed_node_groups = {
    initial = {
      instance_types         = [local.instance_type]
      create_security_group  = false
      create_launch_template = false
      launch_template_name   = ""

      min_size     = var.nodegroup_min_size
      max_size     = var.nodegroup_max_size
      desired_size = var.nodegroup_desired_size

      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }

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

  aws_auth_users = [
    {
      userarn  = data.aws_caller_identity.current.arn
      username = local.current_username
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}

resource "aws_ec2_tag" "public_subnet_tag_elb" {
  count       = length(local.public_subnets)
  resource_id = local.public_subnets[count.index]
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "public_subnet_cluster_tag" {
  count       = length(local.public_subnets)
  resource_id = local.public_subnets[count.index]
  key         = "kubernetes.io/cluster/${local.cluster_name}"
  value       = "owned"
}

resource "aws_ec2_tag" "public_subnet_karpenter_tag" {
  count       = length(local.public_subnets)
  resource_id = local.public_subnets[count.index]
  key         = "karpenter.sh/discovery/${local.cluster_name}"
  value       = local.cluster_name
}