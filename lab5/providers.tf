provider "aws" {
  region = var.aws_region

  access_key = var.use_localstack ? "test" : null
  secret_key = var.use_localstack ? "test" : null

  skip_credentials_validation = var.use_localstack
  skip_metadata_api_check     = var.use_localstack
  skip_requesting_account_id  = var.use_localstack
  skip_region_validation      = var.use_localstack

  s3_use_path_style = var.use_localstack

  endpoints {
    ec2 = var.use_localstack ? "http://localhost:4566" : null
    s3  = var.use_localstack ? "http://localhost:4566" : null
    sts = var.use_localstack ? "http://localhost:4566" : null
  }

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
      Lab       = "ACS730-Lab5"
    }
  }
}
