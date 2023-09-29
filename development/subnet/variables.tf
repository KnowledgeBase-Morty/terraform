variable "vpc_id" {
  type = string
}

variable "public_cidr_blocks" {
  description = "The subnets for public access"
  type        = list(string)
}

variable "public_availbility_zones" {
  description = "The availability zones for public access"
  type        = list(string)
}

variable "private_cidr_blocks" {
  description = "The subnets for private access"
  type        = list(string)
}

variable "private_availbility_zones" {
  description = "The availability zones for private access"
  type        = list(string)
}
