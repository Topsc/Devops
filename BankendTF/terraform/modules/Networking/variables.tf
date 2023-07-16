variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}


variable "public_subnets" {
  description = "List of public subnets"
  default = ["10.10.100.0/24", "10.10.101.0/24"]
}

variable "private_subnets" {
  description = "List of private subnets"
  default = ["10.10.0.0/24", "10.10.1.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}


variable "app_name" {
  type        = string
  description = "Application Name"
  default = "techscrumbackend"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
  default = "uat"
}
