provider "aws" {
  region = var.region
  default_tags {
    tags = var.extra_tags
  }
}
resource "aws_secretsmanager_secret" "customized" {
  count = length(var.secret)
  name = var.secret[count.index]
}

