# Lab 3 - Infrastructure CI/CD Pipeline

A real AWS account would use OIDC (OpenID Connect) to allow GitHub Actions to assume IAM roles dynamically without managing or storing persistent AWS access keys.

This course uses session-scoped credentials from AWS Academy due to IAM permission restrictions on creating OIDC providers, which limits potential leak damage because the temporary keys expire automatically when the lab session ends.
