variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_name" {
  description = "name of vpc"
  type        = string
  default     = "techscrum-VPC"
}

variable "public_subnet_name" {
  description = "name of public subnet"
  type        = string
  default     = "public_subnet"
}

variable "private_subnet_name" {
  description = "name of private subnet"
  type        = string
  default     = "private_subnet"
}

variable "cidr_block_number" {
  description = "first number of cidr block"
  type        = string
  default     = "11"
}
variable "internet_gateway_name" {
  description = "internet gateway name"
  type        = string
  default     = "mytechscrum-igw"
}
variable "public_route_table_name" {
  description = "public route table name"
  type        = string
  default     = "public_route_table"
}
variable "private_route_table_name" {
  description = "private route table name"
  type        = string
  default     = "private_route_table"
}
variable "nat_eip_name" {
  description = "nat eip name"
  type        = string
  default     = "nat_eip"
}
variable "nat_gateway_name" {
  description = "nat gateway name"
  type        = string
  default     = "nat_gateway"
}

variable "ecr_repo" {
  description = "ecr repository name"
  type        = string
  default     = "techscrum-ecr-repo"
}

variable "alb_name" {
  description = "alb name"
  type        = string
  default     = "techscrum-alb"
}

variable "target_group_name" {
  description = "target group name"
  type        = string
  default     = "techscrum-tg"
}

variable "health_check_path" {
  description = "target group health check path"
  type        = string
  default     = "/api/v1/healthcheck"
}

variable "ecs_cluster_name" {
  description = "ecs cluster name"
  type        = string
  default     = "techscrum-cluster"
}

variable "ecs_task_definition_family" {
  description = "ecs task definition family"
  type        = string
  default     = "techscrum-task"
}

variable "ecs_service_name" {
  description = "ecs service name"
  type        = string
  default     = "techscrum-service"
}

variable "alb_security_group_name" {
  description = "alb security group name"
  type        = string
  default     = "alb_sg"
}

variable "service_security_group_name" {
  description = "service security group name"
  type        = string
  default     = "service_sg"
}

variable "cloudwatch_log_group_name" {
  description = "cloudwatch log group name"
  type        = string
  default     = "/ecs/service"
}

variable "UAT_domain_name" {
  description = "UAT domain name"
  type        = string
  default     = "uat.techscrum.jiayuan.click"
}

variable "PROD_domain_name" {
  description = "PROD domain name"
  type        = string
  default     = "prod.techscrum.jiayuan.click"
}

variable "port" {
  description = "The starting port for a range of ports"
  type        = number
  default     = 8000
}

variable "domain_name" {
  description = "domain name"
  type        = string
  default     = "techscrum.jiayuan.click"
}

variable "sns_name" {
  description = "sns name"
  type        = string
  default     = "backend-sns"
}

variable "sns_email" {
  description = "sns email"
  type        = string
}