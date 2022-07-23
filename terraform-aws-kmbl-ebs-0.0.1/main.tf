terraform {
  required_version = ">= 1.0.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.5.0"
    }
  }
}
data "aws_region" "current" {}
provider "aws" {
  region = data.aws_region.current.id
  alias  = "default"
}
resource "aws_ebs_volume" "devops" {
  for_each      = var.additional_disks
  availability_zone = each.value.availability_zone
  size              = each.value.size
  type              = each.value.type
  iops              = each.value.iops

  tags = {
    Name = each.key
  }
}
output "disk_list" {
  value = aws_ebs_volume.devops[*]
}

