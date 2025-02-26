variable "cluster_name" {
    default = "xquare-v3-cluster"
}
variable "irsa_oidc_provider_arn" {
}
variable "iam_role_arn" {
}
variable "cluster_endpoint" {
}
variable "repository" {
    default = "https://team-xquare.github.io/k8s-resource"
}
variable "chart" {
    default = "karpenter"
}
variable "chart_version" {
    default = "0.30.0"
}
variable "namespace" {
    default = "karpenter"
}