variable "alb_security_group_name" {
  description = "alb security group name"
  type        = string
#  default     = "alb_sg"
}

variable "service_security_group_name" {
  description = "service security group name"
  type        = string
#  default     = "service_sg"
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