output "vpc_id" {
  description = "ID of the VPC created by Terraform."
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "IDs of the public subnets."
  value       = { for name, subnet in aws_subnet.public : name => subnet.id }
}

output "web_public_ip" {
  description = "Public IP address of the web server."
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "HTTP URL of the web server."
  value       = "http://${aws_instance.web.public_ip}"
}

output "provider_target" {
  description = "Shows whether Terraform targets LocalStack or real AWS."
  value       = var.use_localstack ? "localstack" : "aws"
}
