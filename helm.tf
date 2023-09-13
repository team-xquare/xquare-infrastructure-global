provider "helm" {
  kubernetes {
    host                   = module.eksv2.cluster_endpoint
    cluster_ca_certificate = module.eksv2.cluster_ca_certificate
    token                  = module.eksv2.cluster_auth_token
  }
}


locals {
  xquare-repository = "https://team-xquare.github.io/k8s-resource"

  argocd-name    = "argocd"
  argocd-verison = "4.8.5"

  aws-node-termination-handler-name    = "aws-node-termination-handler"
  aws-node-termination-handler-version = "0.22.10"

  cert-manager-name    = "cert-manager"
  cert-manager-version = "v1.12.6"

  dex-k8s-authenticator-name    = "dex-k8s-authenticator"
  dex-k8s-authenticator-version = "1.4.4"

  istio-name    = "istio"
  istio-version = "1.0.26"

  karpenter-name    = "karpenter"
  karpenter-version = "1.0.23"

  kube-oidc-proxy-name    = "kube-oidc-proxy"
  kube-oidc-proxy-version = "0.3.3"

  xquare-application-name    = "xquare-application"
  xquare-application-version = "1.0.11"
 
  argocd-namespace       = "argocd"
  dex-namespace          = "dex"
  monitoring-namespace   = "monitoring"
  kube-system-namespace  = "kube-system"
  karpenter-namespace    = "karpenter"
  spot-handler-namespace = "spot-handler"
  cert-manager-namespace = "cert-manager"
  istio-namespace        = "istio-system"
}

module "argocd" {
  source        = "./modules/helm"
  name          = local.argocd-name
  namespace     = local.argocd-namespace
  repository    = local.xquare-repository
  chart         = local.argocd-name
  chart_version = local.argocd-verison
}

module "cert-manager" {
  source        = "./modules/helm"
  name          = local.cert-manager-name
  namespace     = local.cert-manager-namespace
  repository    = local.xquare-repository
  chart         = local.cert-manager-name
  chart_version = local.cert-manager-version
}

module "istio" {
  source        = "./modules/helm"
  name          = local.istio-name
  namespace     = local.istio-namespace
  repository    = local.xquare-repository
  chart         = local.istio-name
  chart_version = local.istio-version
}

module "kube-oidc-proxy" {
  source        = "./modules/helm"
  name          = local.kube-oidc-proxy-name
  namespace     = local.dex-namespace
  repository    = local.xquare-repository
  chart         = local.kube-oidc-proxy-name
  chart_version = local.kube-oidc-proxy-version
}

module "xquare-application" {
  source        = "./modules/helm"
  name          = local.xquare-application-name
  namespace     = local.argocd-namespace
  repository    = local.xquare-repository
  chart         = local.xquare-application-name
  chart_version = local.xquare-application-version
}

module "karpenter" {
  source = "./modules/karpenter"

  namespace     = local.karpenter-namespace
  repository    = local.xquare-repository
  chart         = local.karpenter-name
  chart_version = local.karpenter-version

  cluster_name           = module.eksv2.cluster_name
  irsa_oidc_provider_arn = module.eksv2.oidc_provider_arn
  iam_role_arn           = module.eksv2.iam_role_arn
  cluster_endpoint       = module.eksv2.cluster_endpoint
}
