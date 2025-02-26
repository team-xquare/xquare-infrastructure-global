module "karpenter" {
  source                          = "terraform-aws-modules/eks/aws//modules/karpenter"
  version                         = "20.33.1"
  cluster_name                    = var.cluster_name
  irsa_oidc_provider_arn          = var.irsa_oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  create_iam_role      = false

  node_iam_role_arn    = var.iam_role_arn

  enable_irsa             = true
  create_instance_profile = true
  iam_role_use_name_prefix = false

  iam_role_name          = "KarpenterIRSA-${var.cluster_name}"
  iam_role_description   = "Karpenter IAM role for service account"
  iam_policy_name        = "KarpenterIRSA-${var.cluster_name}"
  iam_policy_description = "Karpenter IAM policy for service account"
}


resource "helm_release" "karpenter" {
  namespace        = var.namespace
  create_namespace = true

  name       = var.chart
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  # set {
  #   name  = "karpenter.settings.clusterName"
  #   value = var.cluster_name
  # }
  #
  # set {
  #   name  = "karpenter.settings.interruptionQueue"
  #   value = var.cluster_name
  # }

  set {
    name  = "karpenter.settings.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "karpenter.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.iam_role_arn
  }

  set {
    name  = "karpenter.aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }

  set {
    name  = "karpenter.settings.aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }
}

