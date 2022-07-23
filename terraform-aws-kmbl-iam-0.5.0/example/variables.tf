// TF VARS

variable "region" {
  description = "Region name for IAM roles"
  type        = string
  default     = "us-east-1"
}

// IAM Role

variable "create_role" {
  description = "Boolean value to decide creation of IAM role"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "IAM role name"
  type        = string
  default     = ""
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

variable "additional_policy_arn" {
  description = "Additional Policy ARNs to be attached to the IAM Role"
  type        = list(any)
  default     = []
}

variable "role_document_path" {
  description = "Absolute path of the JSON template containg IAM assume_role_policy document "
  type        = string
  default     = ""
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
  default     = "IAM Policy managed by Terraform"
}

variable "policy_document_path" {
  description = "Absolute path of the JSON template containg IAM Policy document "
  type        = string
  default     = ""
}

// OIDC

variable "create_oidc_role" {
  description = "Boolean value to enable creation of OIDC Role"
  type        = bool
  default     = false
}

variable "oidc_role_name" {
  description = "IAM role name"
  type        = string
  default     = ""
}

variable "provider_urls" {
  description = "List of URLs of the OIDC Providers"
  type        = list(string)
  default     = []
}

variable "oidc_role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "oidc_fully_qualified_subjects" {
  description = "The fully qualified OIDC subjects to be added to the role policy"
  type        = set(string)
  default     = []
}