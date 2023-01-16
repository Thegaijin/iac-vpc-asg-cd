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

variable "cache_subnet_group_name" {
    type        = string
  description = "name of the elasticache subnet group"
}

variable "cache_cluster_id" {
  type = string
  description = "elasticache cluster ID"
}

variable "cache_engine" {
  type = string
  description = "elasticache cluster engine"
}

variable "cache_engine_version" {
  type = string
  description = "elasticache cluster engine"
}

variable "cache_node_type" {
  type = string
  description = "cache server instance type"
}

variable "cache_parameter_gp_name" {
  type = string
}
