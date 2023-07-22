terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "secondaccount"
  region                  = var.aws_region
}

module "lambda_role_module" {
  source = "./modules/lambda_role"
}

module "opensearch_cluster" {
  source              = "./modules/opensearch_cluster"
  masteruser_name     = var.masteruser_name
  masteruser_password = var.masteruser_password
  domain_name         = var.domain_name
}

module "log_subscription_filter" {
  source               = "./modules/log_subscription_filter"
  app_name             = var.app_name
  app_environment_uat  = var.app_environment_uat
  app_environment_prod = var.app_environment_prod
  role_arn             = module.lambda_role_module.role_arn
  OPENSEARCH_ENDPOINT  = module.opensearch_cluster.OPENSEARCH_ENDPOINT
}



