variable "deployment_group_name" {
  type = string
  description = "deployment group name"
}

variable "umf_host_name" {
  type        = string
  description = "Public DNS name"
}

variable "lb_hostname" {
  type        = string
  description = "DNS Hostname for load balancer"
}

variable "deployment_bucket" {
  type        = string
  description = "code deployment s3 bucket"
}

variable "default_vpc_id" {
  type = number
  description = "id of the account's default vpc"
}

variable "default_vpc_subnet_id" {
  type = string
  description = "id of a subnet in the default vpc"
}
