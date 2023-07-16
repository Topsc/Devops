terraform {
  backend "local" {}
}



provider "aws" {
  region     = var.region
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}

provider "aws" {
  region     = "us-east-1"
  alias = "us-east-1"
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}
