#Instance
variable "instance_count" {}
variable "instance_type" {}
variable "name" {}
variable "owner" {}
variable "ttl" {}
variable "region" {
  default = "us-west-2"
}
