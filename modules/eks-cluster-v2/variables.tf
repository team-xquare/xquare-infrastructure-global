variable "name_prefix" {
}
variable "cluster_version" {
}
variable "vpc_id" {
}
variable "public_subnets" {
}
variable "additional_auth_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}