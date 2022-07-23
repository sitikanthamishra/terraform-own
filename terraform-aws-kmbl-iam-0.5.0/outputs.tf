// IAM Role

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = element(concat(aws_iam_role.this.*.arn, [""]), 0)
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = element(concat(aws_iam_role.this.*.name, [""]), 0)
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = element(concat(aws_iam_role.this.*.path, [""]), 0)
}

output "iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = element(concat(aws_iam_role.this.*.unique_id, [""]), 0)
}

// IAM Policy

output "iam_policy_id" {
  description = "The ARN assigned by AWS to this policy."
  value       = element(concat(aws_iam_policy.this.*.id, [""]), 0)
}

output "iam_policy_arn" {
  description = "The ARN assigned by AWS to this policy."
  value       = element(concat(aws_iam_policy.this.*.arn, [""]), 0)
}

output "iam_policy_name" {
  description = "The name of the policy."
  value       = element(concat(aws_iam_policy.this.*.name, [""]), 0)
}

output "iam_policy_document" {
  description = "The policy document"
  value       = element(concat(aws_iam_policy.this.*.policy, [""]), 0)
}

// OIDC

output "oidc_role_arn" {
  description = "ARN of IAM role"
  value       = element(concat(aws_iam_role.oidc_role.*.arn, [""]), 0)
}

output "oidc_role_name" {
  description = "Name of IAM role"
  value       = element(concat(aws_iam_role.oidc_role.*.name, [""]), 0)
}

output "oidc_role_path" {
  description = "Path of IAM role"
  value       = element(concat(aws_iam_role.oidc_role.*.path, [""]), 0)
}

output "oidc_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = element(concat(aws_iam_role.oidc_role.*.unique_id, [""]), 0)
}
