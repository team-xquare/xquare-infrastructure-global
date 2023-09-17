variable "name_prefix" {
}
variable "cluster_version" {
}
variable "vpc_id" {
}
variable "public_subnets" {
}
variable "instance_type" {
}
variable "capacity_type" {
}

variable "nodegroup_min_size" {
}
variable "nodegroup_max_size" {
}
variable "nodegroup_desired_size" {
}
variable "bootstrap_extra_args" {
}
variable "pre_bootstrap_user_data" {
}

variable "auth_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "auth_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}