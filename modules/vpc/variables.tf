variable "name_prefix" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type    = list(string)
}

variable "public_subnets" {
  type    = list(string)
}

variable "private_subnets" {
  type    = list(string)
}

variable "cluster_name" {
  type = string
}


variable "public_subnet_tags_per_az" {
  type        = map(map(string))
  default     = {}
}