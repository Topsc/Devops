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

variable "oai-iam-arn" {
  
}