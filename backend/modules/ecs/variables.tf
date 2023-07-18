variable "ecs_cluster_name" {
  description = "ecs cluster name"
  type        = string
  # default     = "mytechscrum-cluster"
}

variable "ecs_task_definition_family" {
  description = "ecs task definition family"
  type        = string
  # default     = "mytechscrum-task"
}
variable "cloudwatch_log_group_name" {
  description = "cloudwatch log group name"
  type        = string
  # default     = "/ecs/service"
}
variable "ecs_service_name" {
  description = "ecs service name"
  type        = string
  # default     = "mytechscrum-service"
}

variable "public_subnets_a_id" {
  description = "public subnets a id"
  type        = string
}

variable "public_subnets_b_id" {
  description = "public subnets b id"
  type        = string
}

variable "private_subnets_a_id" {
  description = "private subnets a id"
  type        = string
}

variable "private_subnets_b_id" {
  description = "private subnets b id"
  type        = string
}

variable "service_sg_id" {
  description = "service sg id"
  type        = string
}

variable "repository_url" {
  description = "image repository url"
  type        = string
}


variable "tg_uat_arn" {
  description = "tg uat arn"
  type        = string
}

variable "tg_prod_arn" {
  description = "tg prod arn"
  type        = string
}

variable "listener_arn" {
  description = "ARN of the listener"
  type        = string
}