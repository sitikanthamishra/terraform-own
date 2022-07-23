output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = join("", aws_msk_cluster.msk_cluster.*.arn)
}
output "zookeeper_connect_string" {
  value       = aws_msk_cluster.msk_cluster.zookeeper_connect_string
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster"
}
output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.msk_cluster.bootstrap_brokers_tls
}
output "bootstrap_brokers_scram" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/SCRAM to the kafka cluster."
  value       = join("", aws_msk_cluster.msk_cluster.*.bootstrap_brokers_sasl_scram)
}
output "bootstrap_brokers_iam" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/IAM to the kafka cluster."
  value       = join("", aws_msk_cluster.msk_cluster.*.bootstrap_brokers_sasl_iam)
}
output "current_version" {
  description = "Current version of the MSK Cluster used for updates"
  value       = join("", aws_msk_cluster.msk_cluster.*.current_version)
}
output "aws_msk_configuration" {
  description = "MSK default configuration arn:latest revision"
  value       = "${aws_msk_configuration.mskconfig.arn}:${aws_msk_configuration.mskconfig.latest_revision}"
}
output "cluster_name" {
  description = "MSK Cluster name"
  value       = join("", aws_msk_cluster.msk_cluster.*.cluster_name)
}
output "security_group_id" {
  description = "The ID of the security group rule"
  value       = join("", aws_security_group.sg.*.id)
}
output "security_group_name" {
  description = "The name of the security group rule"
  value       = join("", aws_security_group.sg.*.name)
}
