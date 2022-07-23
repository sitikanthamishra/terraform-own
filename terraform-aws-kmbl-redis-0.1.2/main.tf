provider "aws" {
  region = var.region
}

# Local Block
locals {
  tags = {
    Name             = var.name_prefix,
    Owner            = var.project,
    EnvironmentClass = var.environment_class,
    Tier             = "data"
    ManagedBy        = "terraform"
  }
}

# Elasticache Redis

module "redis" {
  source = "./modules/terraform-aws-elasticache-redis-main"

  name_prefix           = var.name_prefix
  number_cache_clusters = var.number_cache_clusters
  node_type             = var.node_type

  cluster_mode_enabled    = var.cluster_mode_enabled
  replicas_per_node_group = var.replicas_per_node_group
  num_node_groups         = var.num_node_groups

  engine_version           = var.engine_version
  port                     = 6379
  maintenance_window       = var.maintenance_window
  snapshot_window          = var.snapshot_window
  snapshot_retention_limit = 7

  automatic_failover_enabled = true

  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.auth_token

  apply_immediately = true
  family            = var.family
  description       = var.description

  subnet_ids = var.subnet_ids
  vpc_id     = var.vpc_id

  ingress_cidr_blocks = var.ingress_cidr_blocks

  parameter = [
    {
      name  = "repl-backlog-size"
      value = "16384"
    }
  ]
  tags = local.tags
}
