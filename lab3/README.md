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

Terraform uses an S3 backend to store its state remotely. The configuration manages an AWS Systems Manager Parameter Store parameter:

- Name: `/acs730/lab3/greeting`
- Type: `String`
- Value after the GitHub Actions deployment: `hello from GitHub Actions`

## Experiments

### Experiment 1: Temporary AWS Credentials

**Prediction:** GitHub Actions needs the AWS access key, secret key, and session token to authenticate using temporary AWS Academy credentials. If these credentials expire, the workflow may fail with an authentication error.

**Result:** The Lab 3 deployment workflow completed successfully and updated the SSM parameter. This confirms that the configured credentials were valid for that run.

**Explanation:** Temporary credentials include a session token and expire at the end of the AWS Academy session. They must be refreshed when expired before another deployment can authenticate.

### Experiment 2: Terraform Version and AWS Region

**Prediction:** Using Terraform `1.10.3` consistently and configuring the AWS region as `us-east-1` should allow the workflow to initialize and manage the intended resource.

**Result:** The GitHub Actions workflow completed successfully, reporting one resource changed and zero resources added or destroyed. The SSM parameter returned `hello from GitHub Actions` in `us-east-1`.

**Explanation:** Consistent Terraform versions reduce compatibility differences between local and CI environments. The AWS region setting ensures the workflow accesses the intended regional resource.
