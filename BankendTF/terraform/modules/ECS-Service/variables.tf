variable "task-def-family" {
  type=string
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}


variable "app_name" {
  type        = string
  description = "Application Name"
  default = "techscrumbackend"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
  default = "uat"
}

variable "ecs-cluster-id" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "subnet-ids" {
}