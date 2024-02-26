module "karpenter" {
  source                          = "terraform-aws-modules/eks/aws//modules/karpenter"
  version                         = "18.31.0"
  cluster_name                    = var.cluster_name
  irsa_oidc_provider_arn          = var.irsa_oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]
  create_iam_role                 = false
  iam_role_arn                    = var.iam_role_arn
}
 
resource "helm_release" "karpenter" {
  namespace        = var.namespace
  create_namespace = true

  name       = var.chart
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  set {
    name  = "karpenter.setings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "karpenter.setings.interruptionQueue"
    value = var.cluster_name
  }

  set {
    name  = "karpenter.settings.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "karpenter.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "karpenter.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "karpenter.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::471407337433:role/KarpenterControllerRole-xquare-v2-cluster"
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
