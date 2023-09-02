provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = module.eks.cluster_ca_certificate
    token                  = module.eks.cluster_auth_token
  }
}

locals {
    xquare-repository      = "https://team-xquare.github.io/k8s-resource"

    argocd-name = "argocd"
    argocd-verison = "4.8.4"

    aws-ebs-csi-driver-name = "aws-ebs-csi-driver"
    aws-ebs-csi-driver-version = "2.21.0"

    aws-node-termination-handler-name = "aws-node-termination-handler"
    aws-node-termination-handler-version = "0.22.2"

    cert-manager-name = "cert-manager"
    cert-manager-version = "v1.12.3"

    dex-name = "dex"
    dex-version = "0.15.5"

    dex-k8s-authenticator-name = "dex-k8s-authenticator"
    dex-k8s-authenticator-version = "1.4.2"

    istio-name = "istio"
    istio-version = "1.0.19"

    karpenter-name = "karpenter"
    karpenter-version = "1.0.3"

    prometheus-name = "kube-prometheus-stack"
    prometheus-version = "48.3.1"

    redis-name = "redis"
    redis-version = "17.15.6"

    kube-oidc-proxy-name = "kube-oidc-proxy"
    kube-oidc-proxy-version = "0.3.3"

    xquare-application-name = "xquare-application"
    xquare-application-version = "1.0.1"

    xquare-certificate-name = "xquare-certificate"
    xquare-certificate-version = "1.0.3"

    xquare-role-name = "xquare-role"
    xquare-role-version = "1.0.2"

    argocd-namespace       = "argocd"
    dex-namespace          = "dex"
    monitoring-namespace   = "monitoring"
    kube-system-namespace  = "kube-system"
    karpenter-namespace    = "karpenter"
    spot-handler-namespace = "spot-handler"
    cert-manager-namespace = "cert-manager"
    istio-namespace        = "istio-system"
    redis-namespace        = "redis"
}

module "argocd" {
  source     = "./modules/helm"
  name  = local.argocd-name
  namespace     = local.argocd-namespace
  repository    = local.xquare-repository
  chart         = local.argocd-name
  chart_version = local.argocd-verison
}

module "aws-ebs-csi-driver" {
  source     = "./modules/helm"
  name  = local.aws-ebs-csi-driver-name
  namespace     = local.kube-system-namespace
  repository    = local.xquare-repository
  chart         = local.aws-ebs-csi-driver-name
  chart_version = local.aws-ebs-csi-driver-version
}

module "aws-node-termination-handler" {
  source     = "./modules/helm"
  name  = local.aws-node-termination-handler-name
  namespace     = local.spot-handler-namespace
  repository    = local.xquare-repository
  chart         = local.aws-node-termination-handler-name
  chart_version = local.aws-node-termination-handler-version
}

module "cert-manager" {
  source     = "./modules/helm"
  name       = local.cert-manager-name
  namespace  = local.cert-manager-namespace
  repository = local.xquare-repository
  chart      = local.cert-manager-name
  chart_version  = local.cert-manager-version
}

module "dex" {
  source     = "./modules/helm"
  name  = local.dex-name
  namespace   = local.dex-namespace
  repository  = local.xquare-repository
  chart       = local.dex-name
  chart_version = local.dex-version
}

module "dex-k8s-authenticator" {
  source     = "./modules/helm"
  name  = local.dex-k8s-authenticator-name
  namespace   = local.dex-namespace
  repository  = local.xquare-repository
  chart       = local.dex-k8s-authenticator-name
  chart_version = local.dex-k8s-authenticator-version
}

module "istio" {
  source     = "./modules/helm"
  name       = local.istio-name
  namespace  = local.istio-namespace
  repository = local.xquare-repository
  chart      = local.istio-name
  chart_version = local.istio-version
}

module "karpenter" {
  source                 = "./modules/karpenter"

  namespace              = local.karpenter-namespace
  repository             = local.xquare-repository
  chart                  = local.karpenter-name
  chart_version          = local.karpenter-version

  cluster_name           = module.eks.cluster_name
  irsa_oidc_provider_arn = module.eks.oidc_provider_arn
  iam_role_arn           = module.eks.iam_role_arn
  cluster_endpoint       = module.eks.cluster_endpoint
}

module "prometheus" {
  source     = "./modules/helm"
  name       = local.prometheus-name
  namespace  = local.monitoring-namespace
  repository = local.xquare-repository
  chart      = local.prometheus-name
  chart_version  = local.prometheus-version
}

module "redis" {
  source     = "./modules/helm"
  name       = local.redis-name
  namespace  = local.redis-namespace
  repository = local.xquare-repository
  chart      = local.redis-name
  chart_version  = local.redis-version
}

module "xquare-application" {
  source     = "./modules/helm"
  name       = local.xquare-application-name
  repository = local.xquare-repository
  chart      = local.xquare-application-name
  chart_version  = local.xquare-application-version
}

module "xquare-certificate" {
  source     = "./modules/helm"
  name       = local.xquare-certificate-name
  repository = local.xquare-repository
  chart      = local.xquare-certificate-name
  chart_version = local.xquare-certificate-version
}

module "xquare-role" {
  source     = "./modules/helm"
  name       = local.xquare-role-name
  repository = local.xquare-repository
  chart      = local.xquare-role-name
  chart_version = local.xquare-role-version
}
