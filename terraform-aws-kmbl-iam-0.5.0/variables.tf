// Provider
variable "region" {
  type        = string
  description = "provide region name"
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Add extra tags to your resource"
}

// IAM Role

variable "create_role" {
  description = "Boolean value to decide creation of IAM role"
  type        = bool
  default     = false
}

variable "role_name" {
  description = "IAM role name"
  type        = string
  default     = ""
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 3600
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = "Managed by Terraform"
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = false
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = ""
}

variable "assume_role_policy_document" {
  type        = string
  description = "JSON dplicy document which will define trusted entities"
  default     = ""
}

variable "additional_policy_arn" {
  description = "Policy ARN to use for poweruser role"
  type        = list(any)
  default     = []
}

// IAM Policy

variable "create_policy" {
  description = "Boolean value to decide creation of IAM Policy"
  type        = bool
  default     = false
}

variable "policy_name" {
  description = "The name of the policy"
  type        = string
  default     = ""
}

variable "policy_path" {
  description = "The path of the policy in IAM"
  type        = string
  default     = "/"
}

variable "policy_description" {
  description = "The description of the policy"
  type        = string
  default     = "IAM Policy"
}

variable "policy_document" {
  description = "The policy document. This is a JSON formatted string"
  type        = string
  default     = ""
}

// OIDC

variable "create_oidc_role" {
  description = "Boolean value to enable creation of OIDC Role"
  type        = bool
  default     = false
}

variable "provider_urls" {
  description = "List of URLs of the OIDC Providers"
  type        = list(string)
  default     = []
}

variable "aws_account_id" {
  description = "The AWS account ID where the OIDC provider lives, leave empty to use the account for the AWS provider"
  type        = string
  default     = ""
}

variable "oidc_role_name" {
  description = "IAM role name"
  type        = string
  default     = null
}

variable "oidc_role_name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "oidc_role_description" {
  description = "IAM Role description"
  type        = string
  default     = ""
}

variable "oidc_role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "oidc_max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 3600
  validation {
    condition     = var.oidc_max_session_duration >= 3600 && var.oidc_max_session_duration <= 43200
    error_message = "Maximum CLI/API session duration in seconds, is in between 3600 and 43200."
  }
}

variable "oidc_role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "number_of_role_policy_arns" {
  description = "Number of IAM policies to attach to IAM role"
  type        = number
  default     = null
}


variable "oidc_fully_qualified_subjects" {
  description = "The fully qualified OIDC subjects to be added to the role policy"
  type        = set(string)
  default     = []
}

variable "oidc_subjects_with_wildcards" {
  description = "The OIDC subject using wildcards to be added to the role policy"
  type        = set(string)
  default     = []
}

variable "oidc_force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = false
}

// Common
variable "tags" {
  description = "Map of resource tags for the IAM resources"
  type        = map(string)
  default     = {}
}
