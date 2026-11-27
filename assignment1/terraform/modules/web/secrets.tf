data "aws_ssm_parameter" "app_secret" {
  name            = var.parameter_name
  with_decryption = true
}

output "application_secret_loaded" {
  description = "Confirms the application secret is available"
  value       = nonsensitive(length(data.aws_ssm_parameter.app_secret.value) > 0)
}
