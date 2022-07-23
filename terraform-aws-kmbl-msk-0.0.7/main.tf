provider "aws" {
  region = var.region
  default_tags {
    tags = var.extra_tags
  }
}

resource "aws_security_group" "sg" {
  vpc_id      = var.vpc_id
  name        = "sg_msk_${var.cluster_name}_${var.environment_class}"
  description = "Allow inbound traffic from Security Groups and CIDRs. Allow all outbound traffic"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.security_group
  security_group_id        = join("", aws_security_group.sg.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.sg.*.id)
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.sg.*.id)
}

resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    ebs_volume_size = var.ebs_vol_size
    client_subnets  = var.subnets_ids
    security_groups = ["${aws_security_group.sg.id}"]
  }
  configuration_info {
    arn      = aws_msk_configuration.mskconfig.arn
    revision = aws_msk_configuration.mskconfig.latest_revision
  }
  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }
  dynamic "client_authentication" {
    for_each = var.client_tls_auth_enabled || var.client_sasl_scram_enabled || var.client_sasl_iam_enabled ? [1] : []
    content {
      dynamic "tls" {
        for_each = var.client_tls_auth_enabled ? [1] : []
        content {
          certificate_authority_arns = var.certificate_authority_arns
        }
      }
      dynamic "sasl" {
        for_each = var.client_sasl_scram_enabled ? [1] : []
        content {
          scram = var.client_sasl_scram_enabled
        }
      }
      dynamic "sasl" {
        for_each = var.client_sasl_iam_enabled ? [1] : []
        content {
          iam = var.client_sasl_iam_enabled
        }
      }
    }
  }
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enabled
        log_group = var.cloudwatch_logs_log_group
      }
      firehose {
        enabled         = var.firehose_logs_enabled
        delivery_stream = var.firehose_delivery_stream
      }
      s3 {
        enabled = var.s3_logs_enabled
        bucket  = var.s3_logs_bucket
        prefix  = var.s3_logs_prefix
      }
    }
  }
  tags = {
    Name             = var.cluster_name,
    Owner            = var.project,
    EnvironmentClass = var.environment_class,
    Tier             = "data",
    ManagedBy        = "terraform"
  }
}

resource "aws_msk_configuration" "mskconfig" {
  kafka_versions    = [var.kafka_version]
  name              = "kafka-config-${var.environment_class}"
  description       = "Manages an Amazon Managed Streaming for Kafka configuration"
  server_properties = join("\n", [for k in keys(var.properties) : format("%s = %s", k, var.properties[k])])
}
resource "aws_msk_scram_secret_association" "default" {
  count = var.client_sasl_scram_enabled ? 1 : 0

  cluster_arn     = aws_msk_cluster.msk_cluster.arn
  secret_arn_list = var.client_sasl_scram_secret_association_arns
}