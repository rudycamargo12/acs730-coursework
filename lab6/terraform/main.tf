terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "lab6_web" {
  name_prefix = "acs730-lab6-web-"
  description = "Lab 6 web server - no inbound SSH"
  vpc_id      = "vpc-09f164c3e166e37e7"

  ingress {
    description = "HTTP web access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound connectivity for SSM"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "acs730-lab6-web-sg"
    Project = "acs730-lab6"
  }
}

resource "aws_instance" "lab6_web" {
  ami                         = "ami-0aacbf72109c53c0c"
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-024ef07de6aa7cadc"
  vpc_security_group_ids      = [aws_security_group.lab6_web.id]
  iam_instance_profile        = "LabInstanceProfile"
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name    = "acs730-lab6-web"
    Project = "acs730-lab6"
    Role    = "web"
  }
}

output "instance_id" {
  value = aws_instance.lab6_web.id
}

output "public_ip" {
  value = aws_instance.lab6_web.public_ip
}

output "security_group_id" {
  value = aws_security_group.lab6_web.id
}
