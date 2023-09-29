
# Provider
variable "access_key" {
  description = "Access key to AWS console"
  default     = ""
}
variable "secret_key" {
  description = "Secret key to AWS console"
  default     = ""
}
variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "md_eb_keypair" {
  default = "~/.ssh/..."
}

variable "environment_prefix" {
  description = "Prefix for Coud Services in the environment"
  default     = "md-dev"
}
