terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

//shared aws account need to add shared_credentials_file and profile if you use multi aws account
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "secondaccount"
  region                  = var.aws_region
}
//if you use your 
# provider "aws" {
#   region     = var.aws_region
#   access_key = var.aws_access_key
#   secret_key = var.aws_secret_key
# }

terraform {
  backend "s3" {
    //if you use multi aws account, add sahred-credentials_file and profile
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "secondaccount"

    bucket = "techscrum-tfstate-bucket"
    key    = "backend-tfstate/terraform.tfstate"
    region = "ap-southeast-2"

    # Enable during Step-09     
    # For State Locking
    dynamodb_table = "techscrum-lock-table"
  }
}

module "ecr_repository" {
  source = "./modules/ecr_repository" // path to your module

  ecr_repo = var.ecr_repo
}

module "vpc" {
  source                   = "./modules/vpc" // path to your module
  cidr_block_number        = var.cidr_block_number
  vpc_name                 = var.vpc_name
  aws_region               = var.aws_region
  nat_gateway_name         = var.nat_gateway_name
  public_subnet_name       = var.public_subnet_name
  private_subnet_name      = var.private_subnet_name
  internet_gateway_name    = var.internet_gateway_name
  public_route_table_name  = var.public_route_table_name
  private_route_table_name = var.private_route_table_name
  nat_eip_name             = var.nat_eip_name
}

module "sg" {
  source                      = "./modules/sg" // path to your module
  vpc_id                      = module.vpc.vpc_id
  alb_security_group_name     = var.alb_security_group_name
  port                        = var.port
  service_security_group_name = var.service_security_group_name
}

module "alb" {
  source              = "./modules/alb" // path to your module
  vpc_id              = module.vpc.vpc_id
  alb_name            = var.alb_name
  target_group_name   = var.target_group_name
  health_check_path   = var.health_check_path
  alb_sg_id           = module.sg.alb_sg_id
  public_subnets_a_id = module.vpc.public_subnets_a_id
  public_subnets_b_id = module.vpc.public_subnets_b_id
  UAT_domain_name     = var.UAT_domain_name
  PROD_domain_name    = var.PROD_domain_name
}

module "route53be" {
  source = "./modules/route53be" 
  domain_name = var.domain_name
  UAT_domain_name = var.UAT_domain_name
  PROD_domain_name = var.PROD_domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "ecs" {
  source                     = "./modules/ecs" 
  ecs_cluster_name           = var.ecs_cluster_name
  ecs_task_definition_family = var.ecs_task_definition_family
  cloudwatch_log_group_name  = var.cloudwatch_log_group_name
  ecs_service_name           = var.ecs_service_name
  public_subnets_a_id        = module.vpc.public_subnets_a_id
  public_subnets_b_id        = module.vpc.public_subnets_b_id
  private_subnets_a_id       = module.vpc.private_subnets_a_id
  private_subnets_b_id       = module.vpc.private_subnets_b_id
  service_sg_id              = module.sg.service_sg_id
  repository_url             = module.ecr_repository.repository_url
  listener_arn               = module.alb.listener_arn
  tg_uat_arn                 = module.alb.tg_uat_arn
  tg_prod_arn                = module.alb.tg_prod_arn
}

module "cloudwatch" {
  source = "./modules/cloudwatch" 
  alb_name = var.alb_name
  sns_name = var.sns_name
  sns_email = var.sns_email
}