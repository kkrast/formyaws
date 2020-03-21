module "network" {
  source = "./net"
}
module "security" {
  source = "./sec"
  vpc_id = "${module.network.vpc}"
}

resource "aws_vpc" "my-main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = false
  enable_dns_support   = true
  instance_tenancy     = "default"
tags {
    Site = "my-web-site"
    Name = "my-vpc"
  }
}

