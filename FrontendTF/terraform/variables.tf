
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

variable "bucket_name" {
  type        = string
  description = "The name for the S3 bucket"
  default     = "techscrum-linda-frontend"
}
variable "domain_name" {
  type        = string
  description = "The domain name to use"
  default     = "techscrum-dev.lindalu.click"
}
