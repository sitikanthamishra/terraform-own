# Terraform Script to create AWS Elasticsearch_domain

## Resources Created

* Elasticsearch_domain configuration
* Aws_cloudwatch_log_group
* Aws_iam_service_linked_role
* Kibana endpoint


## Best Practices

* Node_to_node_encryption
* Cluster_configuration
* Custom endpoint
* log_publishing_options


## Module reference

https://github.com/lgallard/terraform-aws-elasticsearch/tree/0.11.0

## Step's to upgrade elastic_search_module
Step-1 

Comment the log_publishing_options_default (ref. module/main.tf from line 249 to 254 )

Step-2 

Pass the log_publishing_options as variable instate of local.log_publishing_options(ref. module/main.tf (made changes in dynamic "log_publishing_options") from line-117 to 124)

Step-3 

we have modify IAM.tf file with updated code (ref. module/main.tf from line 1 to 8 )

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_region_name"></a> [region\_name](#input\region\_name) | Region name | `string` | `[]`|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Name of the domain | `string` | `[]` |
| <a name="input_elasticsearch_version"></a> [elasticsearch\_version](#input\_elasticsearch\_version) | The version of Elasticsearch to deploy. | `string` | `[]` |
| <a name="input_cluster_config_instance_type"></a> [cluster\_config\_instance\_type](#input\_cluster\_config\_instance\_type) | Instance type of data nodes in the cluster | `string` | `[]` |
| <a name="input_instance_count"></a> [instance\_count](#input\_cluster\_config\_instance\_count) | Number of instances in the cluster | `number` | `[]` |
| <a name="input_cluster_config_warm_enabled"></a> [cluster\_config\_warm\_enabled](#input\_cluster\_config\_warm\_enabled) | Indicates whether to enable warm storage | `bool` | `[]` |
| <a name="input_cluster_config_warm_count"></a> [cluster\_config\_warm\_count](#input\_cluster\_config\_warm\_count) | The number of warm nodes in the cluster | `number` | `[]` |
| <a name="input_cluster_config_warm_type"></a> [cluster\_config\_warm\_type](#input\_cluster\_config\_warm\_type) | The instance type for the Elasticsearch cluster's warm nodes | `string` | `[]` |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The volume_size of instance to deploy | `number` | `[]` |
| <a name="input_custom_endpoint_enabled"></a> [custom\_endpoint\_enabled](#input\_custom\_endpoint\_enabled) | If want to enable custom_endpoint | `bool` | `[]` |
| <a name="input_custom_endpoint"></a> [custom\_endpoint](#input\_custom\_endpoint) | To set custom_endpoint need endpoint | `string` | `[]` |
| <a name="input_custom_endpoint_certificate_arn"></a> [custom\_endpoint\_certificate\_arn](#input\_custom\_endpoint\_certificate\_arn) | Input for custom endpoint certificate arn | `any` | `[]` |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Input for kms_key_id | `any` | `[]` |
| <a name="input_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#input\_cloudwatch\_log\_group\_arn) | Input for cloudwatch_log_group_arn | `any` | `[]` |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Input for retention_period of log files | `number` | `[]` |
| <a name="input_vpc_subnet_id"></a> [vpc\_subnet\_id](#input\_vpc\_subnet\_id) | List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in | `list(string)` | `[]` |
| <a name="input_Security_group_id"></a> [Security\_group\_id](#input\_Security\_group\_id) | List of VPC Security Group IDs to be applied to the Elasticsearch domain endpoints. If omitted, the default Security Group for the VPC will be used  | `list(string)` | `[]` |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elasticsearch_domain_arn"></a> [elasticsearch\_domain\_arn](#output\elasticsearch\_domain\_arn) | Amazon Resource Name (ARN) of the elasticsearch domain |
| <a name="output_elasticsearch_domain_id"></a> [elasticsearch\_domain\_endpoint\_id](#output\elasticsearch\_domain\_id) | Amazon elasticsearch_domain_id |
| <a name="output_elasticsearch_domain_endpoint"></a> [elasticsearch\_domain\_endpoint](#output\elasticsearch\_domain\_endpoint) | Amazon elasticsearch domain endpoint|
| <a name="output_elasticsearch_domain_kibana_endpoint"></a> [elasticsearch\_domain\_kibana\_endpoint](#output\elasticsearch\_domain\_kibana\_endpoint) |Amazon elasticsearch_domain_kibana_endpoint|






