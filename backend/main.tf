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
//if you want to use your aws credentials
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
    bucket                  = "techscrum-tfstate-bucket"
    key                     = "backend-tfstate/terraform.tfstate"
    region                  = "ap-southeast-2"

    # Enable during Step-09     
    # For State Locking
    dynamodb_table = "techscrum-lock-table"
  }
}

module "ecr_repository" {
  source            = "./modules/ecr_repository" // path to your module
  app_name          = var.app_name
  ecr_images_number = var.ecr_images_number
}

module "vpc" {
  source               = "./modules/vpc" // path to your module
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnets       = var.public_subnets
  aws_region           = var.aws_region
  private_subnets      = var.private_subnets
  availability_zones   = var.availability_zones
  app_name             = var.app_name
  app_environment_uat  = var.app_environment_uat
  app_environment_prod = var.app_environment_prod
}

module "sg" {
  source   = "./modules/sg" // path to your module
  vpc_id   = module.vpc.vpc_id
  app_name = var.app_name
  port     = var.port
}

module "alb" {
  source               = "./modules/alb" // path to your module
  vpc_id               = module.vpc.vpc_id
  app_name             = var.app_name
  app_environment_uat  = var.app_environment_uat
  app_environment_prod = var.app_environment_prod
  health_check_path    = var.health_check_path
  alb_sg_id            = module.sg.alb_sg_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  domain_name          = var.domain_name
}

module "route53" {
  source       = "./modules/route53"
  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "ecs" {
  source               = "./modules/ecs"
  app_name             = var.app_name
  app_environment_uat  = var.app_environment_uat
  app_environment_prod = var.app_environment_prod
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids
  task_desired_count   = var.task_desired_count
  task_min_count       = var.task_min_count
  task_max_count       = var.task_max_count
  port                 = var.port
  service_sg_id        = module.sg.service_sg_id
  repository_url       = module.ecr_repository.repository_url
  listener_arn         = module.alb.listener_arn
  tg_uat_arn           = module.alb.tg_uat_arn
  tg_prod_arn          = module.alb.tg_prod_arn
}

module "cloudwatch" {
  source               = "./modules/cloudwatch"
  app_name             = var.app_name
  app_environment_uat  = var.app_environment_uat
  app_environment_prod = var.app_environment_prod
  sns_email            = var.sns_email
}