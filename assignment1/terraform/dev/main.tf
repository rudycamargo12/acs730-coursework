terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "acs730-lab3-tfstate-095587169727"
    key          = "assignment1/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "web" {
  source = "../modules/web"

  environment      = "dev"
  ami_id           = "ami-0aacbf72109c53c0c"
  instance_type    = "t3.micro"
  vpc_id           = "vpc-09f164c3e166e37e7"
  subnet_id        = "subnet-024ef07de6aa7cadc"
  instance_profile = "LabInstanceProfile"
  parameter_name   = "/acs730/assignment1/dev/app-secret"
  cpu_threshold    = 90
  app_version      = "1.0.0"
}
