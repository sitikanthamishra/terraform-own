variable "ami_id" {
  type        = string
}
variable "key_name" {
  type        = string
}
variable "security_group" {
  type        = list(string)
}
variable "systems" {
  type        = map
}
variable "kms_key_id" {
  type        = string
}
variable "delete_on_termination" {
  type        = bool
}




