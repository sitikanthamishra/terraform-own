variable "region" {
  type        = string
  description = "Region in which Secret needs to create."
  default     = "ap-south-1"
}
variable "secret" {
  type        = list(string)
  description = "List of custom secrets"
  default     = []
}
variable "extra_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
  default     = {}
}
