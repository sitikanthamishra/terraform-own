provider "aws" {
  region = var.region
  default_tags {
    tags = var.extra_tags
  }
}

// Data
data "template_file" "policy_document" {
  template = file("${path.root}//${var.policy_path}")
}

// IAM Role
resource "aws_iam_role" "this" {
  count                 = var.create_role ? 1 : 0
  name                  = var.role_name
  path                  = var.role_path
  max_session_duration  = var.max_session_duration
  description           = var.role_description
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.role_permissions_boundary_arn
  assume_role_policy    = var.assume_role_policy_document
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "existing_policy_attachment" {
  count      = length(var.additional_policy_arn) > 0 && var.create_role ? length(var.additional_policy_arn) : 0
  role       = aws_iam_role.this[0].name
  policy_arn = element(var.additional_policy_arn, count.index)
}

// IAM Policy

resource "aws_iam_policy" "this" {
  count       = var.create_policy ? 1 : 0
  name        = var.policy_name
  description = var.policy_description
  policy      = data.template_file.policy_document.rendered
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "new_policy_attachment" {
  count      = var.create_policy && var.create_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

// IAM Role With OIDC

locals {
  aws_account_id = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.current.account_id
  urls = [
    for url in compact(distinct(var.provider_urls)) :
    replace(url, "https://", "")
  ]
  number_of_role_policy_arns = coalesce(var.number_of_role_policy_arns, length(var.oidc_role_policy_arns))
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  count = var.create_oidc_role ? 1 : 0
  dynamic "statement" {
    for_each = local.urls
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals {
        type        = "Federated"
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${local.aws_account_id}:oidc-provider/${statement.value}"]
      }
      dynamic "condition" {
        for_each = length(var.oidc_fully_qualified_subjects) > 0 ? local.urls : []
        content {
          test     = "StringEquals"
          variable = "${statement.value}:sub"
          values   = var.oidc_fully_qualified_subjects
        }
      }
      dynamic "condition" {
        for_each = length(var.oidc_subjects_with_wildcards) > 0 ? local.urls : []
        content {
          test     = "StringLike"
          variable = "${statement.value}:sub"
          values   = var.oidc_subjects_with_wildcards
        }
      }
    }
  }
}

resource "aws_iam_role" "oidc_role" {
  count                 = var.create_oidc_role ? 1 : 0
  name                  = var.oidc_role_name
  name_prefix           = var.oidc_role_name_prefix
  description           = var.oidc_role_description
  path                  = var.oidc_role_path
  max_session_duration  = var.oidc_max_session_duration
  force_detach_policies = var.oidc_force_detach_policies
  assume_role_policy    = join("", data.aws_iam_policy_document.assume_role_with_oidc.*.json)
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "oidc_attachment" {
  count      = var.create_oidc_role ? local.number_of_role_policy_arns : 0
  role       = join("", aws_iam_role.oidc_role.*.name)
  policy_arn = var.oidc_role_policy_arns[count.index]
}

resource "aws_iam_role_policy_attachment" "oidc_attachment_custom" {
  count      = var.create_oidc_role && var.create_policy ? 1 : 0
  role       = join("", aws_iam_role.oidc_role.*.name)
  policy_arn = aws_iam_policy.this[count.index].arn
}