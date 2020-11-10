locals {
  engine         = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.03.2"
  family         = "aurora-mysql5.7"
}

variable "name" {}
variable "common_tags" {}
variable "vpc" {}
variable "azs" {}
variable "private_subnets" {}
variable "username" {}
variable "instance_class" {}
variable "engine_mode" {}
