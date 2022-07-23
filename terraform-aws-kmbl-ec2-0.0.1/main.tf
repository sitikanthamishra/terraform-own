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
  

resource "aws_instance" "devops" {
  for_each      = var.systems
  ami           = var.ami_id
  instance_type = each.value.instance_type
  vpc_security_group_ids = var.security_group
  key_name = var.key_name
  root_block_device {
    volume_size = each.value.root_volume_size
    volume_type = "gp3"
    encrypted   = true
    delete_on_termination = var.delete_on_termination
    kms_key_id  = var.kms_key_id
  }
  dynamic "ebs_block_device" {
    for_each = each.value.additional_disks
    content  {
    device_name = ebs_block_device.key
    volume_size = ebs_block_device.value.size
    volume_type = ebs_block_device.value.type
    iops        = ebs_block_device.value.iops
    encrypted   = true
    delete_on_termination = var.delete_on_termination
    kms_key_id  = var.kms_key_id
    }
  }
  lifecycle {
    ignore_changes = [
      ebs_block_device,
      root_block_device,
      vpc_security_group_ids
    ]
  }
  availability_zone = each.value.availability_zone
  subnet_id = each.value.subnet_id
  tags = {
    Name = each.key,
    Project = "MB2",
    map-migrated = "d-server-025gtl8atwuak7"
  }
}
output "node_list" {
  value = aws_instance.devops[*]
}
