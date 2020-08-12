data "aws_caller_identity" "current" {}

locals {
  # common
  name           = "wordpress"
  aws_account_id = data.aws_caller_identity.current.account_id

  common_tags = {
    SystemName  = local.name
    Environment = terraform.workspace
  }
}


# network
variable "vpc_cidr" {
  default = {
    dev = "10.1.0.0/16"
    stg = "10.2.0.0/16"
    prd = "10.3.0.0/16"
  }
}

variable "azs" {
  default = ["us-east-1a", "us-east-1d"]
}
