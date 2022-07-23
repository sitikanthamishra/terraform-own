variable "region" {
  type = string
}
variable "broker_instance_type" {
  type        = string
  default     = "kafka.t3.small"
  description = "The instance type to use for the Kafka brokers"
}
variable "kafka_version" {
  type        = string
  default     = "2.8.0"
  description = "The desired Kafka software version"
}
variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}
variable "number_of_broker_nodes" {
  type        = number
  default     = 3
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
}
variable "ebs_vol_size" {
  type        = number
  default     = 1000
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID where subnets will be created (e.g. `vpc-aceb2723`)"
}
variable "environment_class" {
  type        = string
  default     = "dev"
  description = "Environment the MSK cluster is bootstraped (e.g dev, uat, prod)"
}
variable "project" {
  type        = string
  default     = ""
  description = "Name of the project for which MSK is provisioned"
}
variable "subnets_ids" {
  type        = list(any)
  description = "Subnet IDs for Client Broker"
}
variable "security_group" {
  type        = string
  default     = ""
  description = "Security group ID to be allowed to connect to the cluster"
}
variable "allowed_cidr_blocks" {
  type        = list(any)
  default     = []
  description = "List of CIDR blocks to be allowed to connect to the cluster"
}
variable "enhanced_monitoring" {
  type        = string
  default     = "DEFAULT"
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: `DEFAULT`, `PER_BROKER`, and `PER_TOPIC_PER_BROKER`"
}
variable "properties" {
  type = map(any)
  default = {
    "auto.create.topics.enable" = "false"
    "log.retention.hours"       = "-1"
    "offsets.retention.minutes" = "10080"
  }
  description = "Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)"
}
variable "client_tls_auth_enabled" {
  type        = bool
  default     = false
  description = "Set `true` to enable the Client TLS Authentication"
}
variable "client_sasl_scram_enabled" {
  type        = bool
  default     = false
  description = "Enables SCRAM client authentication via AWS Secrets Manager."
}
variable "client_sasl_iam_enabled" {
  type        = bool
  default     = false
  description = "Enables client authentication via IAM policies"
}
variable "certificate_authority_arns" {
  type        = list(any)
  default     = []
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication"
}
variable "encryption_at_rest_kms_key_arn" {
  type        = string
  default     = ""
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest"
}
variable "cloudwatch_logs_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
}

variable "cloudwatch_logs_log_group" {
  type        = string
  default     = null
  description = "Name of the Cloudwatch Log Group to deliver logs to"
}
variable "s3_logs_enabled" {
  type        = bool
  default     = false
  description = " Indicates whether you want to enable or disable streaming broker logs to S3"
}

variable "s3_logs_bucket" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket to deliver logs to"
}

variable "s3_logs_prefix" {
  type        = string
  default     = ""
  description = "Prefix to append to the S3 folder name logs are delivered to"
}
variable "firehose_delivery_stream" {
  type        = string
  default     = ""
  description = "Name of the Kinesis Data Firehose delivery stream to deliver logs to"
}
variable "firehose_logs_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose"
}
variable "client_sasl_scram_secret_association_arns" {
  type        = list(any)
  default     = []
  description = "List of AWS Secrets Manager secret ARNs for scram authentication."
}
variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Add extra tags to your resource"
}