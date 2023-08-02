terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

//shared aws account need to add shared_credentials_file and profile if you use multi aws account
provider "aws" {
  # shared_credentials_file = "~/.aws/credentials"
  # profile = "secondaccount"
  region = var.aws_region
}


###############sg########################
resource "aws_security_group" "monitor-sg" {
  name        = "monitor-sg"
  description = "monitor security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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
    Name = "monitor"
  }
}

######################iam role##################
data "aws_iam_policy_document" "yace_policy_document" {
  statement {
    actions = [
      "tag:GetResources",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "apigateway:GET",
      "aps:ListWorkspaces",
      "autoscaling:DescribeAutoScalingGroups",
      "dms:DescribeReplicationInstances",
      "dms:DescribeReplicationTasks",
      "ec2:DescribeTransitGatewayAttachments",
      "ec2:DescribeSpotFleetRequests",
      "shield:ListProtections",
      "storagegateway:ListGateways",
      "storagegateway:ListTagsForResource"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "yace_policy" {
  name        = "yace_policy"
  description = "yace policy"
  policy      = data.aws_iam_policy_document.yace_policy_document.json
}

resource "aws_iam_role" "ec2_yace_role" {
  name = "ec2_yace_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "yace-ec2-role-attach" {
  role       = aws_iam_role.ec2_yace_role.name
  policy_arn = aws_iam_policy.yace_policy.arn
}

resource "aws_iam_role_policy_attachment" "yace-ec2-role-attach-OpenSearch" {
  role       = aws_iam_role.ec2_yace_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonOpenSearchServiceFullAccess"
}
######################ec2#################################

resource "aws_iam_instance_profile" "ec2_yace_profile" {
  name = "${aws_iam_role.ec2_yace_role.name}-profile"
  role = aws_iam_role.ec2_yace_role.name
}

resource "aws_instance" "monitor-instance" {
  ami           = "ami-05c3b6a7b33d2952c" # This is the Amazon Linux 2 LTS AMI ID for us-east-1
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.monitor-sg.id]
  key_name = "jiayuan-access" 
  iam_instance_profile = aws_iam_instance_profile.ec2_yace_profile.name
  tags = {
    Name = "monitor-instance"
  }
}

data "template_file" "ansible_playbook" {
  template = file("${path.module}/provision_ec2.yml.tpl")

  vars = {
    ansible_host = aws_instance.monitor-instance.public_ip
  }
}

resource "local_file" "AnsiblePlaybook" {
  content  = data.template_file.ansible_playbook.rendered
  filename = "${path.module}/provision_ec2.yml"
}

resource "local_file" "AnsibleInventory" {
  content = "[ec2-instances]\n${aws_instance.monitor-instance.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/jiayuan-access.pem"
  filename = "${path.module}/inventory.ini"
}

resource "null_resource" "ansible_provisioner" {
  # Trigger re-provisioning each time the instance changes
  triggers = {
    instance_id = aws_instance.monitor-instance.id
  }

  provisioner "local-exec" {
    command = <<EOF
      echo "Waiting for SSH to become available..."
      while ! nc -z -v -w5 ${aws_instance.monitor-instance.public_ip} 22; do 
        sleep 5
      done

      echo "SSH is now available. Running ansible-playbook..."
      ansible-playbook -i ${path.module}/inventory.ini ${path.module}/provision_ec2.yml
    EOF
  }
}
