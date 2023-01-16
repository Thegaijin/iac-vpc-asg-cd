output "lb_dns_name" {
  value = aws_lb.umf_prod_lb.dns_name
}

output "prod_sg" {
  value = aws_security_group.prod_sg.id
}

output "iam_role" {
  value = data.aws_iam_role.ec2_iam_role.name
}

# output "redis-cache" {
#   value = aws_elasticache_cluster.umf_redis.endpoint
# }
