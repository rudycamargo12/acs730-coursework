variable "use_localstack" {
  description = "Use LocalStack instead of real AWS."
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region for the infrastructure."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "The AWS region must have a valid format, such as us-east-1."
  }
}

variable "project_name" {
  description = "Project name used to identify resources."
  type        = string
  default     = "acs730-lab5"
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the VPC."
  type        = string
  default     = "10.50.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "public_subnets" {
  description = "Map of public subnet CIDR blocks."
  type        = map(string)

  default = {
    public_a = "10.50.1.0/24"
    public_b = "10.50.2.0/24"
  }
}

variable "allowed_ingress_ports" {
  description = "TCP ports allowed into the web server."
  type        = list(number)
  default     = [22, 80]
}

variable "instance_type" {
  description = "EC2 instance type for the web server."
  type        = string
  default     = "t3.micro"
}

variable "create_bucket" {
  description = "Whether to create the optional S3 bucket."
  type        = bool
  default     = true
}
