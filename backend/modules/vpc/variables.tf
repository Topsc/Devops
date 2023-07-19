variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block  of vpc"
}


variable "public_subnets" {
  type        = list(string) 
  description = "List of public subnets"
}

variable "private_subnets" {
  type        = list(string) 
  description = "List of private subnets"
}

variable "availability_zones" {
  type        = list(string) 
  description = "List of availability zones"
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment_uat" {
  type        = string
  description = "Application Environment"
}

variable "app_environment_prod" {
  type        = string
  description = "Application Environment"
}

