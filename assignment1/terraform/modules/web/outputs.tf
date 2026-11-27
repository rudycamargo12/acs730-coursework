output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web.public_ip
}

output "security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "app_version" {
  description = "Deployed application version"
  value       = var.app_version
}

output "website_url" {
  description = "URL of the deployed web application"
  value       = "http://${aws_instance.web.public_ip}"
}
