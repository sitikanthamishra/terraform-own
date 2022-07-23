provider "aws" {
  region = var.region
  default_tags {
    tags = var.extra_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

# Local Block
locals {
  tags = {
    Name             = var.name,
    Owner            = var.project,
    EnvironmentClass = var.environment_class,
    Tier             = "data",
    ManagedBy        = "terraform"
  }
}
resource "random_password" "master" {
  length  = 10
  special = false
}

# RDS Aurora Postgresql Module

module "rds-aurora" {
  source = "./modules/terraform-aws-rds-aurora-5.2.0"

  name                  = var.name
  engine                = var.engine
  engine_version        = var.engine_version
  instance_type         = var.instance_type
  instance_type_replica = var.instance_type_replica

  vpc_id                  = var.vpc_id
  db_subnet_group_name    = aws_db_subnet_group.postgresql.name
  create_security_group   = var.create_security_group
  allowed_cidr_blocks     = var.allowed_cidr_blocks
  allowed_security_groups = var.allowed_security_groups
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_id
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window

  iam_database_authentication_enabled = var.iam_database_authentication_enabled #Manage your database user credentials through IAM users and roles. IAM administrators control who can be authenticated and authorized for RDS resources.
  password                            = random_password.master.result
  username                            = var.username
  create_random_password              = false

  #availability_zone     = ["${var.region}a", "${var.region}b", "${var.region}c"]

  # Autoscaling of the RDS Replicas
  replica_count         = var.replica_count
  replica_scale_enabled = var.replica_scale_enabled
  replica_scale_min     = var.replica_scale_min
  replica_scale_max     = var.replica_scale_max

  monitoring_interval           = var.monitoring_interval
  iam_role_name                 = "${var.name}-enhanced-monitoring"
  iam_role_use_name_prefix      = var.iam_role_use_name_prefix
  iam_role_description          = "${var.name} RDS enhanced monitoring IAM role"
  iam_role_path                 = "/autoscaling/"
  iam_role_max_session_duration = var.iam_role_max_session_duration

  apply_immediately   = var.apply_immediately
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  db_parameter_group_name         = aws_db_parameter_group.example.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.id
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports_rds
  database_name                   = var.database_name
  tags                            = local.tags

}
resource "aws_secretsmanager_secret" "rds_credentials" {
  name       = "${var.name}-credentials"
  kms_key_id = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = <<EOF
{
  "username": "${var.username}",
  "password": "${random_password.master.result}",
  "engine": "${var.engine}"
}
EOF
}
#Create DB Subnet Group
resource "aws_db_subnet_group" "postgresql" {
  name       = "${var.name}-aurora-subnet-group"
  subnet_ids = var.subnets_ids

  tags = local.tags
}

#Create Parameters

resource "aws_db_parameter_group" "example" {
  name        = "${var.name}-${var.db_family}-parameter-group"
  family      = var.db_family
  description = "${var.name}-${var.db_family}-parameter-group"

  tags = local.tags
}

resource "aws_rds_cluster_parameter_group" "example" {
  name        = "${var.name}-${var.db_family}-cluster-parameter-group"
  family      = var.db_family
  description = "${var.name}-${var.db_family}-cluster-parameter-group"

  parameter {
    name         = "timezone"
    value        = var.timezone
    apply_method = "pending-reboot"
  }

  tags = local.tags
}
