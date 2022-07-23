variable "region" {
  type        = string
  description = "provide region name"
}

variable "es_domain_name" {
  type        = string
  description = "provide domain_name"
}

variable "es_version" {
  type        = string
  default     = "7.1"
  description = "The version of Elasticsearch to deploy"
}

variable "instance_type" {
  type        = string
  default     = "r5.large.elasticsearch"
  description = "The instance_type of Elasticsearch to deploy"

}

variable "instance_count" {
  type        = number
  default     = "3"
  description = "The instance_count to deploy"
}

variable "cluster_config_warm_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether to enable warm storage"
}

variable "cluster_config_warm_count" {
  type        = number
  default     = 3
  description = "The number of warm nodes in the cluster"
}

variable "cluster_config_warm_type" {
  type        = string
  default     = "ultrawarm1.medium.elasticsearch"
  description = "The instance type for the Elasticsearch cluster warm nodes"
}

variable "project_name" {
  type        = string
  description = "Name of the project for which ES is provisioned"
}

variable "environment_class" {
  type        = string
  description = "Environment of the bucket (e.g dev, uat, prod)"
}

variable "volume_size" {
  type        = number
  default     = "10"
  description = "The volume_size of instance to deploy"
}

variable "custom_endpoint_enabled" {
  type        = bool
  description = "Want to enable custom_endpoint"
  default     = false
}

variable "custom_endpoint" {
  type        = string
  description = "Input for custom endpoint"
  default     = null
}

variable "custom_endpoint_certificate_arn" {
  type        = string
  description = "Input for custom endpoint certificate arn"
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = "Input for kms_key_id"
  default     = null
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in"
}

variable "sg_id" {
  type        = list(string)
  description = "Provide security group ID"
}

variable "log_publishing_options_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  default     = 90
}

variable "tags" {
  description = "A map of tags for the resource"
  type        = map(string)
  default     = {}
}

variable "cloudwatch_log_group" {
  type    = list(any)
  default = ["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS", "ES_APPLICATION_LOGS"]
}

variable "cloudwatch_log_enabled" {
  description = "Change to false to avoid deploying any Cloudwatch Logs resources"
  type        = bool
  default     = true
}
variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Add extra tags to your resource"
}
variable "create_service_link_role" {
  description = "Create service link role for AWS Elasticsearch Service"
  type        = bool
  default     = true
}
variable "snapshot_options_automated_snapshot_start_hour" {
  default     = 23
  type        = number
  description = "Automated snapshot start hour"
}