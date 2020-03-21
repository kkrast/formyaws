provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
  profile = "kkrastev-free-kalin"
}

terraform {
  backend "s3" {
    bucket = "task-terraform-backend"
    key = "terraform-environment-task-all"
    region = "eu-west-1"
    dynamodb_table = "terraform-lock"
  }
}

