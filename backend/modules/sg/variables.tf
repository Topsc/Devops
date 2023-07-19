
variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "techscrum"
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "port" {
  description = "The starting port for a range of ports"
  type        = number
#   default     = 8000
}