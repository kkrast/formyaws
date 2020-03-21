variable "vpc_id" {}
# security groups
variable "sg_web" {}
variable "sg_db" {}
# subnets
variable "sn_web1" {}
variable "sn_web2" {}
variable "sn_db1" {}
variable "sn_db2" {}

# config artifact
variable "database_name" {}
variable "database_user" {}
# secrets artifact
variable "database_password" {}
# instance key pair
variable "key_name" {}
