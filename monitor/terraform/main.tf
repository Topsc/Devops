terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
}

variable "key_name" {
  type = string
  default = "ansible_key_pair"
}

resource "aws_security_group" "techscrum_ansible" {
  name        = "techscrum_ansible"
  description = "Security group for Techscrum ansible course"
  vpc_id      = var.vpc_id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 9090
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 9090
    },
    {
      cidr_blocks = [
         "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 3000
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      to_port          = 3000
      self             = false
    },
  ]

  tags = {
    Name    = "techscrum_ansible"
    Project = "techscrum-monitor"
  }
}

resource "aws_instance" "techscrum-monitor-ec2" {
  ami             = "ami-0567f647e75c7bc05"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.techscrum_ansible.name]
  key_name = var.key_name

  tags = {
    Name    = "techscrum-monitor"
    Project = "techscrum"
  }
}


variable "vpc_id" {
  type = string
  default = "vpc-0402e1532b1ccb078"
}



# security group all
#ami-04b9e92b5572fa0d1