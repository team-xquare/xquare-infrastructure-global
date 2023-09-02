locals {
  elasticcache_name = "xquare-redis"
  elasticcache_engine = "redis"
  elasticcache_engin_version = "7.0"
  elasticcache_node_type = "cache.t2.micro"
  elasticcache_parameter_group_name = "default.redis7"
}

resource "aws_security_group" "elasticache_sg" {
  name_prefix = local.elasticcache_name
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "${local.elasticcache_name}-cache-subnet"
  subnet_ids = module.vpc.private_subnet_ids
}

resource "aws_elasticache_cluster" "xquare-cluster" {
  cluster_id           = local.elasticcache_name
  engine               = local.elasticcache_engine
  engine_version       = local.elasticcache_engin_version
  node_type            = local.elasticcache_node_type
  num_cache_nodes      = 1
  parameter_group_name = local.elasticcache_parameter_group_name
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnet_group
  security_group_ids = [ aws_security_group.elasticache_sg.vpc_id ]
}