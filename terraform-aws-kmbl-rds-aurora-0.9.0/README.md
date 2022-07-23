# AWS Terraform RDS Aurora Postgresql Cluster

Terraform script which creates RDS Aurora Postgresql resources on AWS.

## Resource Created

* RDS Aurora Postgresql Cluster
* Security Group for RDS
* Subnet Group for RDS
* DataBase Parameter Group
* RDS Cluster Parameter Group
* IAM role for RDS enhanced monitoring
* Secret Manager


## Best Practices

* HA Postgresql Cluster with Multiple Read Replicas
* Encryption at rest
* Backup Policy
* Enhanced Monitoring Enabled
* Random Generated Database Master Password
* Storing Postgresql Logs in CloudWatch 
* Storing Credentials in Secret Manager


## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | A list of CIDR blocks which are allowed to access the database | `list(string)` | `[]` |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | A list of Security Group ID's to allow access to | `list(string)` | `[]` |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Determines whether or not any DB modifications are applied immediately, or during the maintenance window | `bool` | `true` |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Determines whether minor engine upgrades will be performed automatically in the maintenance window | `bool` | `true` |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Whether cluster should be created (it affects almost all resources) | `bool` | `false` |
| <a name="input_create_monitoring_role"></a> [create\_monitoring\_role](#input\_create\_monitoring\_role) | Whether to create the IAM role for RDS enhanced monitoring | `bool` | `true` |
| <a name="input_create_random_password"></a> [create\_random\_password](#input\_create\_random\_password) | Whether to create random password for RDS primary cluster | `bool` | `true` |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create security group for RDS cluster | `bool` | `true` |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name for an automatically created database on cluster creation | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the DB instance should have deletion protection enabled | `bool` | `true` |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to export to cloudwatch - `audit`, `error`, `general`, `slowquery`, `postgresql` | `list(string)` | `[postgresql]` |
| <a name="input_engine"></a> [engine](#input\_engine) | Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql | `string` | `"aurora"` |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Aurora database engine version | `string` | `"5.6.10a"` |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too. | `string` | `"final"` |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | The global cluster identifier specified on aws\_rds\_global\_cluster | `string` | `""` |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether IAM Database authentication should be enabled or not. Not all versions and instances are supported. Refer to the AWS documentation to see which versions are supported | `bool` | `false` |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use at master instance. If instance\_type\_replica is not set it will use the same type for replica instances | `string` | `""` |
| <a name="input_instance_type_replica"></a> [instance\_type\_replica](#input\_instance\_type\_replica) | Instance type to use at replica instance | `string` | `null` |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights is enabled or not | `bool` | `false` |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead. | `number` | `""` |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. | `bool` | `false` |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the underlying storage layer should be encrypted | `bool` | `false` |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs used by database subnet group created | `list(string)` | `[]` |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Sets the timezone for displaying and interpreting time stamps in rds | `string` | `ASIA/CALCUTTA` |
| <a name="input_username"></a> [username](#input\_username) | Master DB username | `string` | `"root"` |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | `""` |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate to the cluster in addition to the SG we create in this module | `list(string)` | `[]` |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_cluster_database_name"></a> [rds\_cluster\_database\_name](#output\_rds\_cluster\_database\_name) | Name for an automatically created database on cluster creation |
| <a name="output_rds_cluster_endpoint"></a> [rds\_cluster\_endpoint](#output\_rds\_cluster\_endpoint) | The cluster endpoint |
| <a name="output_rds_cluster_id"></a> [rds\_cluster\_id](#output\_rds\_cluster\_id) | The ID of the cluster |
| <a name="output_rds_cluster_instance_dbi_resource_ids"></a> [rds\_cluster\_instance\_dbi\_resource\_ids](#output\_rds\_cluster\_instance\_dbi\_resource\_ids) | A list of all the region-unique, immutable identifiers for the DB instances |
| <a name="output_rds_cluster_instance_endpoints"></a> [rds\_cluster\_instance\_endpoints](#output\_rds\_cluster\_instance\_endpoints) | A list of all cluster instance endpoints |
| <a name="output_rds_cluster_instance_ids"></a> [rds\_cluster\_instance\_ids](#output\_rds\_cluster\_instance\_ids) | A list of all cluster instance ids |
| <a name="output_rds_cluster_master_password"></a> [rds\_cluster\_master\_password](#output\_rds\_cluster\_master\_password) | The master password |
| <a name="output_rds_cluster_master_username"></a> [rds\_cluster\_master\_username](#output\_rds\_cluster\_master\_username) | The master username |
| <a name="output_rds_cluster_port"></a> [rds\_cluster\_port](#output\_rds\_cluster\_port) | The port |
| <a name="output_rds_cluster_reader_endpoint"></a> [rds\_cluster\_reader\_endpoint](#output\_rds\_cluster\_reader\_endpoint) | The cluster reader endpoint |
| <a name="output_rds_cluster_resource_id"></a> [rds\_cluster\_resource\_id](#output\_rds\_cluster\_resource\_id) | The Resource ID of the cluster |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The security group ID of the cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
