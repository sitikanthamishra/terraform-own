#PROVIDER CONFIGURATION

variable "region" {
  type        = string
  description = "Provide the region where RDS needs to provisioned"
  default     = "ap-south-1"
}
variable "assume_role_arn" {
  description = "Assume role in which account to create"
  type        = string
  default     = ""
}
variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Add extra tags to your resource"
}

#RDS CONFIGURATION

variable "name" {
  type        = string
  description = "Name given to the RDS creater "
}
variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
}
variable "username" {
  type        = string
  default     = "root"
  description = "Master DB username"
}
variable "engine" {
  type    = string
  default = "aurora-postgresql"
  # Only engine type currently aurora, 'aurora-mysql' or 'aurora-postgresql'
  description = "Aurora database engine type, currently aurora, 'aurora-mysql' or 'aurora-postgresql' "
}
variable "engine_version" {
  type        = string
  default     = "11.9"
  description = "Aurora database engine version"
}
variable "instance_type" {
  type        = string
  default     = "db.t3.small"
  description = "Instance type to use for RDS"
}
variable "db_family" {
  type        = string
  default     = "aurora-postgresql11"
  description = "DB family that this DB parameter group will apply to"
}
variable "auto_minor_version_upgrade" {
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
  type        = bool
  default     = true
}
variable "timezone" {
  type        = string
  description = "Provide the timezone"
  default     = "ASIA/CALCUTTA"
}

#NETWORKING

variable "vpc_id" {
  type        = string
  description = "VPC id in which DB needs to launch"
}
variable "subnets_ids" {
  description = "List of subnet IDs used by database subnet group created"
  type        = list(string)
  default     = []
}
variable "create_security_group" {
  type        = bool
  default     = true
  description = "Whether to create security group for RDS cluster"
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to"
  type        = list(string)
  default     = []
}

#TAGS

variable "project" {
  type        = string
  description = "Project name where the RDS is provisioned"
}
variable "environment_class" {
  type        = string
  description = "Environment of the RDS cluster is bootstraped (e.g dev, uat, prod)"
}

#AUTHENTICATION

variable "iam_database_authentication_enabled" {
  type        = bool
  default     = false
  description = "Use an authentication token . An authentication token is a unique string of characters that Amazon RDS generates on request."
}
variable "iam_role_use_name_prefix" {
  type        = bool
  default     = false
  description = "Whether to use name provided in 'name' or create a unique name for the iam role beginning with 'name'"
}
variable "iam_role_max_session_duration" {
  type        = number
  default     = 3600
  description = "Maximum session duration (in seconds) that you want to set for the role"
}

#ENCRYPTION

variable "storage_encrypted" {
  type        = bool
  default     = true
  description = "Specifies whether the underlying storage layer should be encrypted"
}
variable "kms_key_id" {
  type        = string
  description = "Specify the KMS Key to use for encryption"
}

#BACKUP AND  DATA RETENTION CONFIGURATION

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}
variable "deletion_protection" {
  type        = bool
  default     = false
  description = "If the DB instance should have deletion protection enabled"
}
variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created."
}
variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "02:00-03:00"
}

#REPLICA AUTOSCALING CONFIGURATION

variable "replica_scale_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable autoscaling for RDS Aurora read replicas"
}
variable "instance_type_replica" {
  description = "Instance type to use at replica instance"
  type        = string
  default     = null
}
variable "replica_count" {
  type        = number
  default     = 3
  description = "Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead."
}
variable "replica_scale_min" {
  type        = number
  default     = 3
  description = "Minimum number of Replicas for Scalling Policy"
}
variable "replica_scale_max" {
  type        = number
  default     = 5
  description = "Maximum number of Replicas for Scalling Policy"
}

#MONITORING

variable "monitoring_interval" {
  type        = number
  default     = 60
  description = "Monitoring Interval"
}
variable "enabled_cloudwatch_logs_exports_rds" {
  type        = list(string)
  default     = ["postgresql"]
  description = "List of log types to export to cloudwatch - `audit`, `error`, `general`, `slowquery`, `postgresql`"
}

#MAINTENANCE

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
}











