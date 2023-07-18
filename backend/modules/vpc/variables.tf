variable "aws_region" {
  description = "AWS region"
  type        = string
  # default     = "ap-southeast-2"
}

variable "vpc_name" {
  description = "name of vpc"
  type        = string
  # default     = "mytechscrum-VPC"
}

variable "public_subnet_name" {
  description = "name of public subnet"
  type        = string
   #default     = "public_subnet"
}

variable "private_subnet_name" {
  description = "name of private subnet"
  type        = string
  #default     = "private_subnet"
}

variable "cidr_block_number" {
  description = "first number of cidr block"
  type        = string
  #default     = "11"
}
variable "internet_gateway_name" {
  description = "internet gateway name"
  type        = string
  #default     = "mytechscrum-igw"
}
variable "public_route_table_name" {
  description = "public route table name"
  type        = string
  #default     = "public_route_table"
}
variable "private_route_table_name" {
  description = "private route table name"
  type        = string
  #default     = "private_route_table"
}
variable "nat_eip_name" {
  description = "nat eip name"
  type        = string
  #default     = "nat_eip"
}
variable "nat_gateway_name" {
  description = "nat gateway name"
  type        = string
  #default     = "nat_gateway"
}
