data "aws_caller_identity" "this" {}

locals {
  common_tags = {
    Account = data.aws_caller_identity.this.account_id
  }
}

data "template_file" "role_document" {
  count    = var.create_role ? 1 : 0
  template = file("${path.module}/${var.role_document_path}")
}

data "template_file" "policy_document" {
  count    = var.create_policy ? 1 : 0
  template = file("${path.module}/${var.policy_document_path}")
}

module "iam" {
  source = "../"
  tags   = local.common_tags

  create_role                 = var.create_role
  role_name                   = var.role_name
  role_description            = var.role_description
  max_session_duration        = var.max_session_duration
  assume_role_policy_document = var.create_role ? data.template_file.role_document[0].rendered : ""
  additional_policy_arn       = var.additional_policy_arn

  create_policy      = var.create_policy
  policy_name        = var.policy_name
  policy_description = var.policy_description
  policy_path        = var.policy_path
  policy_document    = var.create_policy ? data.template_file.policy_document[0].rendered : ""

  create_oidc_role              = var.create_oidc_role
  oidc_role_name                = var.oidc_role_name
  provider_urls                 = var.provider_urls
  oidc_role_policy_arns         = var.oidc_role_policy_arns
  oidc_fully_qualified_subjects = var.oidc_fully_qualified_subjects
}