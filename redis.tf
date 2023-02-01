resource "aws_elasticache_subnet_group" "redis" {
  name       = var.cache_subnet_group_name
  subnet_ids = data.aws_subnets.prod.ids
}

resource "aws_elasticache_cluster" "umf_redis" {
  cluster_id           = var.cache_cluster_id
  engine               = var.cache_engine
  node_type            = var.cache_node_type
  num_cache_nodes      = 1
  parameter_group_name = var.cache_parameter_gp_name
  engine_version       = var.cache_engine_version
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}
