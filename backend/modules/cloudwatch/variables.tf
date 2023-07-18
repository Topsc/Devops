variable "alb_name" {
  description = "alb name"
  type        = string
}

variable "sns_name" {
  description = "sns name"
  type        = string
}

variable "sns_email" {
  description = "sns email"
  type        = string
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