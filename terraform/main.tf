terraform {
  required_version = "0.12.28"
}

provider "aws" {
  version = "3.1"
}

module "network" {
  source      = "./modules/aws/network"
  name        = local.name
  common_tags = local.common_tags

  vpc_cidr = var.vpc_cidr[terraform.workspace]
  azs      = var.azs
}
