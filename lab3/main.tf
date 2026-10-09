terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "acs730-lab3-tfstate-095587169727"
    key          = "lab3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

resource "aws_s3_bucket" "lab3_bucket" {
  bucket_prefix = "acs730-lab3-resource-"
  force_destroy = true
}
