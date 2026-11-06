use_localstack = true
aws_region     = "us-east-1"
project_name   = "acs730-lab5"
vpc_cidr       = "10.50.0.0/16"

public_subnets = {
  public_a = "10.50.1.0/24"
  public_b = "10.50.2.0/24"
}

allowed_ingress_ports = [22, 80]
instance_type         = "t3.micro"
create_bucket         = true
