resource "helm_release" "this" {
  name       = var.name
  namespace  = try(var.namespace)
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  replace           = var.replace
  cleanup_on_fail   = var.cleanup_on_fail
  create_namespace  = var.create_namespace
}
