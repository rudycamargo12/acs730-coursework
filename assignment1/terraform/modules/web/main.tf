terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  name = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Version     = var.app_version
  }
}

resource "aws_security_group" "web" {
  name_prefix = "${local.name}-web-"
  description = "Web security group for ${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP web access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound connectivity"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name}-sg"
  })
}

resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  iam_instance_profile        = var.instance_profile
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-SCRIPT
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    echo "<h1>ACS730 Assignment 1</h1><p>Environment: ${var.environment}</p><p>Version: ${var.app_version}</p>" > /var/www/html/index.html
  SCRIPT

  user_data_replace_on_change = true

  tags = merge(local.common_tags, {
    Name = "${local.name}-web"
    Role = "web"
  })
}
