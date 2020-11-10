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

module "database" {
  source      = "./modules/aws/database"
  name        = local.name
  common_tags = local.common_tags

  # network
  vpc             = module.network.vpc
  private_subnets = module.network.private_subnets
  azs             = var.azs

  # db param
  username       = var.db_username[terraform.workspace]
  instance_class = var.db_instance_type[terraform.workspace]
  engine_mode    = var.db_engine_mode[terraform.workspace]
}

module "web" {
  source         = "./modules/aws/web"
  env            = terraform.workspace
  name           = local.name
  common_tags    = local.common_tags
  aws_account_id = local.aws_account_id

  # domain
  domain       = local.web_domain
  route53_zone = module.domain.route53_zone

  # network
  vpc             = module.network.vpc
  azs             = var.azs
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets

  # param
  instance_type      = local.web_instance_type
  key_pair_file_path = local.key_pair_file_path

  # other
  db_security_group  = module.database.security_group
  web_alb_log_bucket = module.storage.web_alb_log_bucket.id
}

module "security" {
  source      = "./modules/aws/security"
  env         = terraform.workspace
  name        = local.name
  common_tags = local.common_tags

  aws_account_id       = local.aws_account_id
  cloudtrail_s3_bucket = module.storage.cloudtrail_s3_bucket.id
}

module "domain" {
  source       = "./modules/aws/domain"
  naked_domain = local.naked_domain
}

module "storage" {
  source      = "./modules/aws/storage"
  env         = terraform.workspace
  name        = local.name
  common_tags = local.common_tags

  aws_account_id          = local.aws_account_id
  web_alb_service_account = module.web.web_alb_service_account.id
}
