provider "aws" {
  region = var.region
  default_tags {
    tags = var.extra_tags
  }
}

data "aws_caller_identity" "current" {}

## elasticsearch_domain

module "elasticsearch_domain" {
  source                = "./modules/terraform-aws-elasticsearch-0.11.0"
  domain_name           = var.es_domain_name
  elasticsearch_version = var.es_version

  cluster_config = {
    dedicated_master_enabled = true
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    zone_awareness_enabled   = false
    availability_zone_count  = 1
    warm_enabled             = var.cluster_config_warm_enabled
    warm_count               = var.cluster_config_warm_count
    warm_type                = var.cluster_config_warm_type
  }

  tags = {
    Name             = var.es_domain_name,
    Owner            = var.project_name,
    EnvironmentClass = var.environment_class,
    ManagedBy        = "terraform"
  }

  ebs_options = {
    ebs_enabled = true
    volume_size = var.volume_size
  }

  domain_endpoint_options = {
    count                           = var.custom_endpoint_enabled ? 1 : 0
    enforce_https                   = true
    custom_endpoint                 = var.custom_endpoint
    custom_endpoint_certificate_arn = var.custom_endpoint_certificate_arn
  }
  encrypt_at_rest = {
    enabled    = true
    kms_key_id = var.kms_key_id
  }

  vpc_options = {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.sg_id
  }
  access_policies = templatefile("${path.module}/access_policies.tpl", {
    region      = var.region
    account     = data.aws_caller_identity.current.account_id,
    domain_name = var.es_domain_name

  })
  node_to_node_encryption_enabled                = true
  snapshot_options_automated_snapshot_start_hour = var.snapshot_options_automated_snapshot_start_hour
  create_service_link_role                       = var.create_service_link_role
}
