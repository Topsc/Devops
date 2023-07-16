
variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "bucket_prefix" {
  type        = string
  description = "The prefix for the S3 bucket"
  default     = "techscrum-fe-"
}
variable "domain_name" {
  type        = string
  description = "The domain name to use"
  default     = "techscrum-dev.lindalu.click"
}
