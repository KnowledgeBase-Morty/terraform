variable "vpc_id" {
  type = string
}

variable "load_balancer_security_group_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}
