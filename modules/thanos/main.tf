resource "helm_release" "this" {
  name       = var.name
  namespace  = var.namespace
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  set {
    name  = "karpenter.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.s3_role_arn
  }
}