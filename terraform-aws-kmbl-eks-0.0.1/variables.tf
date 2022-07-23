#-------------------------------
# EKS Cluster Labels
#-------------------------------
variable "cluster_version" {
  type        = string
  description = "Kubernetes Version"
  default     = "1.22"
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
  default     = "test-MB2"
}

#-------------------------------
# VPC Config for EKS Cluster
#-------------------------------
variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "data_plane_private_subnet_ids" {
  description = "List of private subnets Ids for the cluster and worker nodes"
  type        = list(string)
  default     = []
}

variable "control_plane_private_subnet_ids" {
  description = "List of private subnets Ids for the cluster and worker nodes"
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "List of public subnets Ids for the worker nodes"
  type        = list(string)
  default     = []
}


#-------------------------------
# EKS Cluster Security Groups
#-------------------------------
variable "cluster_additional_security_group_ids" {
  description = "List of additional, externally created security group IDs to attach to the cluster control plane"
  type        = list(string)
  default     = []
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source"
  type        = any
  default     = {}
}

#-------------------------------
# EKS Cluster VPC Config
#-------------------------------
variable "cluster_endpoint_public_access" {
  type        = bool
  default     = false
  description = "Indicates whether or not the EKS public API server endpoint is enabled. Default to EKS resource and it is true"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  default     = true
  description = "Indicates whether or not the EKS private API server endpoint is enabled. Default to EKS resource and it is false"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

#-------------------------------
# EKS Cluster ENCRYPTION
#-------------------------------
variable "cluster_kms_key_arn" {
  type        = string
  default     = null
  description = "A valid EKS Cluster KMS Key ARN to encrypt Kubernetes secrets"
}

#-------------------------------
# EKS Cluster CloudWatch Logging
#-------------------------------
variable "cluster_enabled_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "A list of the desired control plane logging to enable"
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 90 days"
  type        = number
  default     = 90
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
  default     = null
}

#-------------------------------
# Worker Additional Variables
#-------------------------------
variable "worker_additional_security_group_ids" {
  description = "A list of additional security group ids to attach to worker instances"
  type        = list(string)
  default     = []
}
#------------------------------
# Other Variables
#------------------------------
variable "custom_ami_id" {
  description = "custom AMI ID"
  type        = string
  default     = ""
}
variable "platform_instance_types" {
  description = "instance types"
  type        = list(string)
}
variable "business_instance_types" {
  description = "instance types"
  type        = list(string)
}
variable "worker_volume_size" {
  description = "worker volume size"
  type        = number
  default     = 150
}
variable "platform_desired_size" {
  description = "Desired number of worker node per subnet"
  type        = number
  default     = 2
}
variable "business_desired_size" {
  description = "Desired number of worker node per subnet"
  type        = number
  default     = 2
}
variable "platform_max_size" {
  description = "maximum number of worker node per subnet"
  type        = number
  default     = 2
}
variable "business_max_size" {
  description = "maximum number of worker node per subnet"
  type        = number
  default     = 2
}
variable "platform_min_size" {
  description = "minimum number of worker node per subnet"
  type        = number
  default     = 1
}
variable "business_min_size" {
  description = "minimum number of worker node per subnet"
  type        = number
  default     = 1
}
variable "aws_load_balancer_controller_helm_repo" {
  description = "AWS load balancer controller helm repo"
  type        = string
  default     = ""
}
variable "aws_load_balancer_controller_helm_version" {
  description = "AWS load balancer controller helm version"
  type        = string
  default     = "1.4.1"
}
variable "aws_load_balancer_controller_image" {
  description = "AWS load balancer controller image"
  type        = string
  default     = ""
}
variable "aws_load_balancer_controller_image_tag" {
  description = "AWS load balancer controller image tag"
  type        = string
  default     = "v2.4.1"
}
variable "metrics_server_helm_repo" {
  description = "Metrics server  helm repo"
  type        = string
  default     = ""
}
variable "metrics_server_helm_version" {
  description = "Metrics server helm version"
  type        = string
  default     = "3.8.2"
}
variable "metrics_server_image" {
  description = "Metrics server image"
  type        = string
  default     = ""
}
variable "metrics_server_image_tag" {
  description = "Metrics server image tag"
  type        = string
  default     = "v0.6.1"
}
variable "cluster_autoscaler_helm_repo" {
  description = "cluster autoscaler helm repo"
  type        = string
  default     = ""
}
variable "cluster_autoscaler_helm_version" {
  description = "cluster autoscaler helm version"
  type        = string
  default     = "9.18.0"
}
variable "cluster_autoscaler_image" {
  description = "cluster autoscaler image"
  type        = string
  default     = ""
}
variable "cluster_autoscaler_image_tag" {
  description = "cluster autoscaler image tag"
  type        = string
  default     = "v1.23.0"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "capacity_type" {
  description = "capacity type"
  type        = string
  default     = "ON_DEMAND"
}
variable "admin_users"{
  description = "admin users for EKS"
  type        = list(string)
  default     = []
}

	
