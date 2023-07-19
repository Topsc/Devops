terraform {
  backend "s3" {
    bucket = "techscrum-tfstate-bucket"
    key    = "frontend-tfstate/terraform.tfstate"
    region = "ap-southeast-2"

    # Enable during Step-09     
    # For State Locking
    dynamodb_table = "techscrum-lock-table"
  }
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
