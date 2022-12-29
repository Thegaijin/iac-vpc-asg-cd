variable "deployment_group_name" {
  type        = string
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
