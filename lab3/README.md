# Lab 3 - Infrastructure CI/CD Pipeline

## Overview

This lab implements an Infrastructure as Code (IaC) pipeline using Terraform and GitHub Actions to deploy AWS infrastructure.

The pipeline validates Terraform configuration and runs a plan for pull requests. When changes are pushed to the `main` branch, GitHub Actions runs Terraform apply.

## Credential Model

In a production environment, GitHub Actions can use OpenID Connect (OIDC) to assume an AWS IAM role without storing long-lived AWS access keys.

This course uses temporary, session-scoped credentials from AWS Academy because of IAM permission restrictions on creating OIDC providers.

The GitHub repository uses the following secrets:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN`

The repository also uses the `AWS_REGION` variable to configure the AWS region.

These credentials expire when the AWS Academy session ends and must be refreshed before the next deployment.

## Common Errors and Troubleshooting

### ExpiredToken

The `ExpiredToken` error occurs when temporary AWS credentials have expired. Start a new AWS Academy session and run:

`./scripts/refresh-gha-creds.sh rudycamargo12/acs730-coursework`

Follow the script instructions to update the GitHub Actions secrets.

### Missing AWS_REGION

The AWS region must be configured for the GitHub Actions workflow. If `AWS_REGION` is missing, verify that the repository variable is configured correctly and that the workflow references `${{ vars.AWS_REGION }}`.

### Terraform Version

This lab uses Terraform `1.10.3`. The local environment and GitHub Actions workflows should use the same version to avoid version-related inconsistencies.

## Infrastructure

Terraform uses an S3 backend to store its state remotely. The configuration creates an AWS Systems Manager Parameter Store parameter:

- Name: `/acs730/lab3/greeting`
- Type: `String`
- Default value: `hello from the workstation`

## Experiments

### Experiment 1: Temporary AWS Credentials

The lab uses temporary AWS Academy credentials rather than permanent access keys. The `AWS_SESSION_TOKEN` is required along with the access key and secret key. When the session expires, GitHub Actions can fail with `ExpiredToken`. Refreshing the credentials allows subsequent deployments to authenticate again.

### Experiment 2: Terraform Version and Region Configuration

Terraform requires a compatible version and a correctly configured AWS region. This lab uses Terraform `1.10.3` and configures the region as `us-east-1`. Keeping the local and workflow versions consistent helps avoid compatibility problems, while configuring `AWS_REGION` allows GitHub Actions to select the intended AWS region.
