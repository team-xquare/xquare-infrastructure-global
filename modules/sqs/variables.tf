variable "name" {
  type = string
}

variable "fifo_queue" {
  type    = bool
  default = true
}

variable "content_based_deduplication" {
  type    = bool
  default = true
}