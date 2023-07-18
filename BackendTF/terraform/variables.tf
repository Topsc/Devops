variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}


variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}


variable "sns_name" {
  description = "sns name"
  type        = string
  default     = "backend-sns"
}

variable "sns_email" {
  description = "sns email"
  type        = string
  default = "chaolin1984@gmail.com"
}

variable "ecs_cluster_name" {
  description = "ecs cluster name"
  type        = string
  default     = "mytechscrum-cluster"
}

variable "ecs_service_name" {
  description = "ecs service name"
  type        = string
  default     = "mytechscrum-service"
}