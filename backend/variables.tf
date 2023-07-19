variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_cidr_block" {
  description = "cidr block  of vpc"
  type        = string
  default     = "11.0.0.0/16"
}


variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
  default     = ["11.0.0.0/20", "11.0.16.0/20"]
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
  default     = ["11.0.128.0/20", "11.0.144.0/20"]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "techscrum"
}

variable "app_environment_uat" {
  type        = string
  description = "Application Environment"
  default     = "uat"
}

variable "app_environment_prod" {
  type        = string
  description = "Application Environment"
  default     = "prod"
}

variable "health_check_path" {
  description = "target group health check path"
  type        = string
  default     = "/api/v1/healthcheck"
}

variable "port" {
  description = "The starting port for a range of ports"
  type        = number
  default     = 8000
}

variable "ecr_images_number" {
  description = "The starting port for a range of ports"
  type        = number
  default     = 5
}
variable "task_desired_count" {
  description = "desired count of tasks"
  type        = number
  default     = 2
}

variable "task_min_count" {
  description = "min count of tasks"
  type        = number
  default     = 2
}

variable "task_max_count" {
  description = "min count of tasks"
  type        = number
  default     = 4
}

variable "domain_name" {
  description = "domain name"
  type        = string
  default     = "techscrum.jiayuan.click"
}

variable "sns_email" {
  description = "sns email"
  type        = string
}