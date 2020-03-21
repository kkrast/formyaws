module "ec2-resourses" {
  source = "./app"
  sg_web = "${var.sg_web}"
  sn_web1 = "${var.sn_web1}"
  sn_web2 = "${var.sn_web2}"
  key_name = "${var.key_name}"
}
module "db" {
  source = "./db"
  sg_db  = "${var.sg_db}"
  sn_db1 = "${var.sn_db1}"
  sn_db2 = "${var.sn_db2}"
  database_name     = "${var.database_name}"
  database_user     = "${var.database_user}"
  database_password = "${var.database_password}"
}

#### VARIABLES
variable "profile" {}
variable "region" {}
variable "database_name" {}
variable "database_user" {}
variable "database_password" {}
variable "key_name" {
  default = "my-key-pair"
}
#### CALL MDOULES
module "core_infra" {
  source  = "./infra"
  profile = "${var.profile}"
  region  = "${var.region}"
}
module "webapp" {
  source   = "./webapp"
  profile  = "${var.profile}"
  region   = "${var.region}"
  key_name = "${var.key_name}"

  # pass web security group and public networks
  sg_web = "${module.core_infra.sg_web}"
  sn_web = "${module.core_infra.sn_pub1}"
  # pass database security group and private networks
  sg_db  = "${module.core_infra.sg_db}"
  sn_db1 = "${module.core_infra.sn_priv1}"
  sn_db2 = "${module.core_infra.sn_priv2}"
  # database parameters
  database_name     = "${var.database_name}"
  database_user     = "${var.database_user}"
  database_password = "${var.database_password}"
}