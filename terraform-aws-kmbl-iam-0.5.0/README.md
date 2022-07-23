# terraform-aws-xebia-iam

Terraform Module to provision:
- [IAM Role](#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)
- [IAM Policy](#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)
- [IAM Role for OIDC](#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)

## Module reference

https://github.com/terraform-aws-modules/terraform-aws-iam/tree/v4.2.0

## Inputs

|Resource Type| Name | Description | Type | Default |
|-------------|------|-------------|------|---------|
| IAM Role | <a name="create_role"></a> [create_role](#create_role) | The IAM Role needs to be created.| `bool` | `false` |
| IAM Role | <a name="role_name"></a> [role_name](#role_name) | The name of the IAM Role. and name should be unique name. | `string` | `[]` |
| IAM Role | <a name="role_path"></a> [role_path](#role_path) | The path of the json policy attached to the role. | `string` | `/` |
| IAM Role | <a name="max_session_duration"></a> [max_session_duration](#max_session_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200. | `number` | `3600` |
| IAM Role | <a name="role_description"></a> [role_description](#role_description) |IAM Role description. | `string` | `[]` |
| IAM Role | <a name="force_detach_policies"></a> [force_detach_policies](#force_detach_policies) | Whether policies should be detached from this role when destroying | `bool` | `false` |
| IAM Role | <a name="role_permissions_boundary_arn"></a> [role_permissions_boundary_arn](#role_permissions_boundary_arn) | Permissions boundary ARN to use for IAM role| `string` | `""` |
| IAM Role | <a name="assume_role_policy_document"></a> [assume_role_policy_document](#assume_role_policy_document) | JSON dplicy document which will define trusted entities. | `string` | `""` |
| IAM Role | <a name="additional_policy_arn"></a> [additional_policy_arn](#additional_policy_arn) | Policy ARN to use for poweruser role. | `list(any)` | `[]` |
| IAM Policy | <a name="create_policy"></a> [create_policy](#create_policy) | Boolean value to decide creation of IAM Policy | `bool` | `false` |
| IAM Policy | <a name="policy_name"></a> [policy_name](#policy_name) | Boolean value to decide creation of IAM Policy. Must be unique. | `string` | `""` |
| IAM Policy | <a name="policy_path"></a> [policy_path](#policy_path) | The path of the policy in IAM | `string` | `""` |
| IAM Policy | <a name="policy_description"></a> [policy_description](#policy_description) |The description of the policy  | `string` | `IAM Policy` |
| IAM Policy | <a name="policy_document"></a> [policy_document](#policy_document) |The policy document. This is a JSON formatted string  | `string` | `""` |
| OIDC IAM Role | <a name="create_oidc_role"></a> [create_oidc_role](#create_oidc_role) | Boolean value to enable creation of OIDC Role | `bool` | `false` |
| OIDC IAM Role | <a name="provider_urls"></a> [provider_urls](#provider_urls) | List of URLs of the OIDC Providers | `list(string)` | `[]` |
| OIDC IAM Role | <a name="aws_account_id"></a> [aws_account_id](#aws_account_id) | The AWS account ID where the OIDC provider lives, leave empty to use the account for the AWS provider | `string` | `""` |
| OIDC IAM Role | <a name="oidc_role_name"></a> [oidc_role_name](#oidc_role_name) | IAM role name | `string` | `NULL` |
| OIDC IAM Role | <a name="oidc_role_name_prefix"></a> [oidc_role_name_prefix](#oidc_role_name_prefix) | IAM role name prefix | `string` | `NULL` |
| OIDC IAM Role | <a name="oidc_role_description"></a> [oidc_role_description](#oidc_role_description) | IAM Role description | `string` | `""` |
| OIDC IAM Role | <a name="oidc_role_path"></a> [oidc_role_path](#oidc_role_path) | Path of IAM role | `string` | `""` |
| OIDC IAM Role | <a name="oidc_max_session_duration"></a> [oidc_max_session_duration](#oidc_max_session_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200 | `number` | `3600` |
| OIDC IAM Role | <a name="oidc_role_policy_arns"></a> [oidc_role_policy_arns](#oidc_role_policy_arns) | oidc_role_policy_arns | `list(string)` | `[]` |
| OIDC IAM Role | <a name="number_of_role_policy_arns"></a> [number_of_role_policy_arns](#number_of_role_policy_arns) | Number of IAM policies to attach to IAM role | `number` | `NULL` |
| OIDC IAM Role | <a name="oidc_fully_qualified_subjects"></a> [oidc_fully_qualified_subjects](#oidc_fully_qualified_subjects) | The fully qualified OIDC subjects to be added to the role policy | `set(string)` | `[]` |
| OIDC IAM Role | <a name="oidc_subjects_with_wildcards"></a> [oidc_subjects_with_wildcards](#oidc_subjects_with_wildcards) | The OIDC subject using wildcards to be added to the role policy | `set(string)` | `[]` |
| OIDC IAM Role | <a name="oidc_force_detach_policies"></a> [oidc_force_detach_policies](#oidc_force_detach_policies) | Whether policies should be detached from this role when destroying | `bool` | `false` |
| Common | <a name="tags"></a> [tags](#tags) | Map of resource tags for the IAM resources | `map(string)` | `{}` |





## Outputs

|Resource Type| Name | Description |
|-------------|------|-------------|
| IAM Role | <a name="iam_role_arn"></a> [iam_role_arn](#iam_role_arn) | ARN of IAM role |
| IAM Role | <a name="iam_role_name"></a> [iam_role_name](#iam_role_name) | Name of IAM role |
| IAM Role | <a name="iam_role_path"></a> [iam_role_path](#iam_role_path) | Path of IAM role |
| IAM Role | <a name="iam_role_unique_id"></a> [iam_role_unique_id](#iam_role_unique_id) | Unique ID of IAM role |
| IAM Policy| <a name="iam_policy_id"></a> [iam_policy_id](#iam_policy_id) | The ARN assigned by AWS to this policy |
| IAM Policy | <a name="iam_policy_arn"></a> [iam_policy_arn](#iam_policy_arn) | The ARN assigned by AWS to this policy. |
| IAM Policy | <a name="iam_policy_name"></a> [iam_policy_name](#iam_policy_name) | The name of the policy. |
| IAM Policy | <a name="iam_policy_document"></a> [iam_policy_document](#iam_policy_document) | The policy document |
| OIDC IAM Role | <a name="oidc_role_arn"></a> [oidc_role_arn](#oidc_role_arn) | ARN of IAM role |
| OIDC IAM Role | <a name="oidc_role_arn"></a> [oidc_role_arn](#oidc_role_arn) | Name of IAM role |
| OIDC IAM Role | <a name="oidc_role_path"></a> [oidc_role_path](#oidc_role_path) | Path of IAM role |
| OIDC IAM Role | <a name="oidc_role_unique_id"></a> [oidc_role_unique_id](#oidc_role_unique_id) | Unique ID of IAM role |
