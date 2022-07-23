terraform {
  required_version = ">= 1.0.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }
  # Terraform state configuration
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
  name = module.aws-eks-accelerator-for-terraform.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.aws-eks-accelerator-for-terraform.eks_cluster_id
}

provider "aws" {
  region = data.aws_region.current.id
  alias  = "default"
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}


data "aws_subnet" "private" {
  for_each = toset(var.data_plane_private_subnet_ids)
  id = each.key
}

locals {
  cluster_version = var.cluster_version
  cluster_name = var.cluster_name
  vpc_id      = var.vpc_id
  data_plane_private_subnet_ids = var.data_plane_private_subnet_ids
  control_plane_private_subnet_ids = var.control_plane_private_subnet_ids
  cluster_kms_key_arn = var.cluster_kms_key_arn
  cluster_enabled_log_types = var.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id = var.cloudwatch_log_group_kms_key_id
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  worker_additional_security_group_ids = var.worker_additional_security_group_ids
  cluster_additional_security_group_ids = var.cluster_additional_security_group_ids
  tags = var.tags
  custom_ami_id = var.custom_ami_id
  platform_instance_types = var.platform_instance_types
  business_instance_types = var.business_instance_types
  platform_desired_size  = var.platform_desired_size
  business_desired_size  = var.business_desired_size
  platform_max_size = var.platform_max_size
  business_max_size = var.business_max_size
  platform_min_size = var.platform_min_size
  business_min_size = var.business_min_size
  volume_size = var.worker_volume_size
  node_group_names = ["platform", "business"]
  capacity_type = var.capacity_type
  admin_users = var.admin_users
  
  

  availability_zone_subnets = {
    for s in data.aws_subnet.private : s.id => s.availability_zone
  }
  nodegroups = {
    for k, v in local.node_group_names : "${v}" => {
      # Node Group configuration
      node_group_name = "${v}" # Max 40 characters for node group name
      enable_node_group_prefix = false
      # custom_ami_id is optional when you provide ami_type. Enter the Custom AMI id if you want to use your own custom AMI
      custom_ami_id  = local.custom_ami_id
      capacity_type  = local.capacity_type  # ON_DEMAND or SPOT
      instance_types = "$(v}" == "platform" ? local.platform_instance_types : local.business_instance_types # List of instances used only for SPOT type

      # Launch template configuration
      create_launch_template = true              # false will use the default launch template
      launch_template_os     = "amazonlinux2eks" # amazonlinux2eks or bottlerocket

      # pre_userdata will be applied by using custom_ami_id or ami_type
      pre_userdata = <<-EOT
            yum install -y amazon-ssm-agent
            systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent
            systemctl disable iptables && systemctl stop  iptables 
            vgextend  vg-01 /dev/xvdb
            lvextend -L +150G /dev/vg-01/var_vol
            lvextend -L +40G /dev/vg-01/var-log_vol
            xfs_growfs /dev/vg-01/var_vol
            xfs_growfs /dev/vg-01/var-log_vol
        EOT

      # post_userdata will be applied only by using custom_ami_id
      post_userdata = <<-EOT
            echo "Bootstrap successfully completed! You can further apply config or install to run after bootstrap if needed"
      EOT


      enable_monitoring = true
      eni_delete        = true
      public_ip         = false # Use this to enable public IP for EC2 instances; only for public subnets used in launch templates

      # Node Group scaling configuration
      desired_size    =  "$(v}" == "platform" ? local.platform_desired_size : local.business_desired_size  
      max_size        = "$(v}" == "platform" ? local.platform_max_size : local.business_max_size
      min_size        =  "$(v}" == "platform" ? local.platform_min_size : local.business_min_size
      max_unavailable = 1 # or percentage = 20

      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          volume_type = "gp3"
          volume_size = 100
        },
        {
          device_name = "/dev/xvdb"
          volume_type = "gp3"
          volume_size = local.volume_size
        }
      ]

      # Node Group network configuration
      subnet_type = "private" # public or private - Default uses the private subnets used in control plane if you don't pass the "subnet_ids"
      subnet_ids  = local.data_plane_private_subnet_ids     # Defaults to private subnet-ids used by EKS Control plane. Define your private/public subnets list with comma separated subnet_ids  = ['subnet1','subnet2','subnet3']

      additional_iam_policies = [] # Attach additional IAM policies to the IAM role attached to this worker group


      additional_tags = {
        ExtraTag    = "${v}"
        Name        = "${v}"
        subnet_type = "private"
      }

    }
  }
  

  terraform_version = "Terraform v1.0.1"
}

module "aws-eks-accelerator-for-terraform" {
  source = "git::https://github.com/aws-ia/terraform-aws-eks-blueprints.git?ref=v4.0.8"

  cluster_name = local.cluster_name
  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = local.vpc_id
  private_subnet_ids = local.control_plane_private_subnet_ids

  # EKS CONTROL PLANE VARIABLES
  cluster_version = local.cluster_version
  #worker_security_group_ids = []

  # Step 1. Set cluster API endpoint both private and public
  cluster_endpoint_public_access  = local.cluster_endpoint_public_access
  cluster_endpoint_private_access = local.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = local.cluster_endpoint_public_access_cidrs


  cluster_kms_key_arn = local.cluster_kms_key_arn
  cluster_enabled_log_types = local.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = local.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id = local.cloudwatch_log_group_kms_key_id

  tags = local.tags
  platform_teams = {
    admin = {
      users = local.admin_users
    }
  }

  ### Worker Node Configuration ###
  worker_additional_security_group_ids = local.worker_additional_security_group_ids
  cluster_additional_security_group_ids = local.cluster_additional_security_group_ids
  node_security_group_additional_rules = {
  ingress_allow_access_from_control_plane = {
    type                          = "ingress"
    protocol                      = "tcp"
    from_port                     = 0
    to_port                       = 65535
    source_cluster_security_group = true
    description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
  }
  ingress_allow_access_from_control_plane_udp  = {
    type                          = "ingress"
    protocol                      = "udp"
    from_port                     = 0
    to_port                       = 65535
    source_cluster_security_group = true
    description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
  }
  allow_access_from_data_plane = {
    type                          = "ingress"
    protocol                      = "tcp"
    from_port                     = 0
    to_port                       = 65535
    self                          = true
    description                   = "Allow access between  worker node for  pod to pod  connection"
  }
  allow_access_from_data_plane_udp = {
    type                          = "ingress"
    protocol                      = "udp"
    from_port                     = 0
    to_port                       = 65535
    self                          = true
    description                   = "Allow access between  worker node for  pod to pod  connection"
  }
  egress_from_worker_node_tcp = {
    type                          = "egress"
    protocol                      = "tcp"
    from_port                     = 0
    to_port                       = 65535
    cidr_blocks                   = ["0.0.0.0/0"]
    description                   = "Allow internet access from worker node"
  }
  egress_from_worker_node_udp = {
    type                          = "egress"
    protocol                      = "udp"
    from_port                     = 0
    to_port                       = 65535
    cidr_blocks                   = ["0.0.0.0/0"]
    description                   = "Allow internet access from worker node"
  }
}


  managed_node_groups = local.nodegroups

}

module "kubernetes-addons" {
  source = "git::https://github.com/aws-ia/terraform-aws-eks-blueprints.git//modules/kubernetes-addons?ref=v4.0.8"

  eks_cluster_id               = module.aws-eks-accelerator-for-terraform.eks_cluster_id
  eks_cluster_endpoint         = module.aws-eks-accelerator-for-terraform.eks_cluster_endpoint
  eks_oidc_provider            = module.aws-eks-accelerator-for-terraform.oidc_provider
  eks_cluster_version          = module.aws-eks-accelerator-for-terraform.eks_cluster_version
  eks_worker_security_group_id = module.aws-eks-accelerator-for-terraform.worker_node_security_group_id
  auto_scaling_group_names     = module.aws-eks-accelerator-for-terraform.self_managed_node_group_autoscaling_groups

  # EKS Addons
  enable_amazon_eks_vpc_cni = true # default is false
  amazon_eks_vpc_cni_config = {
    addon_version = "v1.11.2-eksbuild.1"
  }  
  amazon_eks_aws_ebs_csi_driver_config = {
    addon_version = "v1.6.2-eksbuild.0"
  }
  enable_amazon_eks_coredns = true # default is false
  enable_amazon_eks_kube_proxy = true # default is false
  enable_amazon_eks_aws_ebs_csi_driver  = true # default is false
  #---------------------------------------
  # AWS LOAD BALANCER INGRESS CONTROLLER HELM ADDON
  #---------------------------------------
  enable_aws_load_balancer_controller = true
  # Optional
  aws_load_balancer_controller_helm_config = {
    name       = "aws-load-balancer-controller"
    chart      = "aws-load-balancer-controller"
    repository = var.aws_load_balancer_controller_helm_repo  # Repository URL where to locate the requested chart.
    version    = var.aws_load_balancer_controller_helm_version
    namespace  = "kube-system"
    values = [
     file("${path.module}/helm/albc_values.yaml")
    ]
    set = [{
      name  = "image.repository"
      value = var.aws_load_balancer_controller_image # Replace with your private container image
    },
    {
      name  = "image.tag"
      value = var.aws_load_balancer_controller_image_tag
    },
    {
      name  = "clusterName"
      value = var.cluster_name
    }]
  }

  #---------------------------------------
  # METRICS SERVER HELM ADDON
  #---------------------------------------
  enable_metrics_server = true
  # Optional Map value
  metrics_server_helm_config = {
    name       = "metrics-server"                                    # (Required) Release name.
    repository =  var.metrics_server_helm_repo # Repository URL where to locate the requested chart.
    chart      = "metrics-server"                                    # (Required) Chart name to be installed.
    version    = var.metrics_server_helm_version                                            # (Optional) Specify the exact chart version to install.
    values = [
     file("${path.module}/helm/ms_values.yaml")
    ]
    set = [{
      name  = "image.repository"
      value = var.metrics_server_image # Replace with your private container image
    },
    {
      name  = "image.tag"
      value = var.metrics_server_image_tag
    }]
  }


  # #---------------------------------------
  # # CLUSTER AUTOSCALER HELM ADDON
  # #---------------------------------------
  enable_cluster_autoscaler = true
  # Optional Map value
  cluster_autoscaler_helm_config = {
    name       = "cluster-autoscaler"                      # (Required) Release name.
    repository = var.cluster_autoscaler_helm_repo # Repository URL where to locate the requested chart.
    chart      = "cluster-autoscaler"                      # (Required) Chart name to be installed.
    version    = var.cluster_autoscaler_helm_version                                 # (Optional) Specify the exact chart version to install.
    namespace  = "kube-system"                             # (Optional) The namespace to install the release into.
    timeout    = "1200"                                    # (Optional)
    lint       = "true"                                    # (Optional)
    set = [
      {
        name  = "image.repository"
        value = var.cluster_autoscaler_image # Replace with your private container image
      },
      {
        name  = "image.tag"
        value = var.cluster_autoscaler_image_tag
      },
      {
        name  = "replicaCount"
        value = 3
      },
      {
        name  = "extraArgs.aws-use-static-instance-list"
        value = true
      },
      {
        name  = "extraArgs.balance-similar-node-groups"
        value = true
      },
      {
        name  = "extraArgs.expander"
        value = "least-waste"
      },
      {
        name  = "extraArgs.skip-nodes-with-system-pods"
        value = false
      }
    ]
  }
}



