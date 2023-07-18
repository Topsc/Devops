///create a security group for  ALB
resource "aws_security_group" "alb_sg" {
  name        = var.alb_security_group_name
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
        description = "Allow HTTPS traffic"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.alb_security_group_name
  }
}

///create a security group for service
resource "aws_security_group" "service_sg" {
  name        = var.service_security_group_name
  description = "Allow inbound traffic on port 8000"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound traffic on port 8000"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.service_security_group_name
  }
}