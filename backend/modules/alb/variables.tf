variable "alb_name" {
  description = "alb name"
  type        = string
}

variable "target_group_name" {
  description = "target group name"
  type        = string
}

variable "health_check_path" {
  description = "target group health check path"
  type        = string
}

variable "alb_sg_id" {
  description = "alb sg id"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "public_subnets_a_id" {
  description = "public subnets a id"
  type        = string
}

variable "public_subnets_b_id" {
  description = "public subnets b id"
  type        = string
}

variable "UAT_domain_name" {
  description = "UAT domain name"
  type        = string
}

variable "PROD_domain_name" {
  description = "PROD domain name"
  type        = string
}