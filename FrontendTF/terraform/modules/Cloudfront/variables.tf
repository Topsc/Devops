
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

variable "input_s3_bucket" {
  description = "The regional domain name of the S3 bucket"
}

variable "input_acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "oai-iam" {
  
}