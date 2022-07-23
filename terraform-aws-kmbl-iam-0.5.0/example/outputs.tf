// IAM Role

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.iam.iam_role_arn
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = module.iam.iam_role_name
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = module.iam.iam_role_path
}

output "iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.iam.iam_role_unique_id
}

// IAM Policy

output "iam_policy_id" {
  description = "The ARN assigned by AWS to this policy."
  value       = module.iam.iam_policy_id
}

output "iam_policy_arn" {
  description = "The ARN assigned by AWS to this policy."
  value       = module.iam.iam_policy_arn
}

output "iam_policy_name" {
  description = "The name of the policy."
  value       = module.iam.iam_policy_name
}

output "iam_policy_document" {
  description = "The policy document"
  value       = module.iam.iam_policy_document
}

// OIDC

output "oidc_role_arn" {
  description = "ARN of IAM role"
  value       = module.iam.oidc_role_arn
}

output "oidc_role_name" {
  description = "Name of IAM role"
  value       = module.iam.oidc_role_name
}

output "oidc_role_path" {
  description = "Path of IAM role"
  value       = module.iam.oidc_role_path
}

output "oidc_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.iam.oidc_role_unique_id
}