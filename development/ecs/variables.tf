variable "repository_url" {
  type = string
}

variable "task_execution_role_arn" {
  type = string
}

variable "load_balancer_target_group_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "esc_securitygroup_id" {
  type = string
}
