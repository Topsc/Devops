variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "domain_name" {
  description = "domain name of the opensearch cluster"
  type        = string
  default     = "logs-opensearch"
}

variable "masteruser_name" {
  description = "masteruser name"
  type        = string
  default     = "admin"
}

variable "masteruser_password" {
  description = "masteruser password"
  type        = string
  default     = "Admin10$"
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