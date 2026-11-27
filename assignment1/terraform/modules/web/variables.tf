variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "acs730-assignment1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging or prod."
  }
}

variable "ami_id" {
  description = "Amazon Linux AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "VPC ID for the infrastructure"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "instance_profile" {
  description = "IAM instance profile"
  type        = string
  default     = "LabInstanceProfile"
}

variable "parameter_name" {
  description = "SSM application parameter name"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization alarm threshold"
  type        = number
  default     = 80
}

variable "app_version" {
  description = "Application release version"
  type        = string
  default     = "1.0.0"
}
