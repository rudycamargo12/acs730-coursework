output "instance_id" {
  value = module.web.instance_id
}

output "public_ip" {
  value = module.web.public_ip
}

output "security_group_id" {
  value = module.web.security_group_id
}

output "environment" {
  value = module.web.environment
}

output "app_version" {
  value = module.web.app_version
}

output "website_url" {
  value = module.web.website_url
}

output "application_secret_loaded" {
  value = module.web.application_secret_loaded
}
