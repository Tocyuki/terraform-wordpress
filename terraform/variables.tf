data "aws_caller_identity" "current" {}

locals {
  # common
  name           = "wordpress"
  aws_account_id = data.aws_caller_identity.current.account_id

  common_tags = {
    SystemName  = local.name
    Environment = terraform.workspace
  }

  # domain
  naked_domain = "tocyuki.net"
  web_domain   = "dev.${local.naked_domain}"

  # web
  web_instance_type  = "t3a.nano"
  key_pair_file_path = "./user_files/.ssh/dev_rsa.pub"
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

# db
variable "db_username" {
  default = "root"
}

variable "db_instance_type" {
  default = {
    dev = "db.t2.small"
    stg = "db.r5.large"
    prd = "db.r5.xlarge"
  }
}

variable "db_engine_mode" {
  default = {
    dev = "provisioned"
    stg = "serverless"
    prd = "serverless"
  }
}
