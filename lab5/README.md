# ACS730 - Lab 5: Terraform Networking with LocalStack

## Overview

This lab uses Terraform to build a complete AWS-style network infrastructure.
The configuration supports two targets: real AWS and LocalStack, controlled
by the `use_localstack` variable.

The infrastructure includes:

- One VPC.
- Two public subnets using `for_each`.
- One Internet Gateway.
- One public route table and subnet associations.
- One security group with dynamic ingress rules.
- One optional S3 bucket controlled by `count`.
- One EC2 web server using an AMI data source and user_data.

## Terraform Design

The configuration uses typed variables, validation rules, locals, data sources,
resource references, `for_each`, `count`, dynamic blocks and explicit
dependencies.

The provider target is controlled by `use_localstack`.

For local testing:

```bash
terraform -chdir=lab5 init -backend=false
terraform fmt -check -recursive lab5
terraform -chdir=lab5 validate
terraform -chdir=lab5 plan -var-file=localstack.tfvars
terraform -chdir=lab5 apply -var-file=localstack.tfvars
```

## Why LocalStack Instead of Real AWS in CI?

Running Terraform against real AWS on every pull request is slower because
cloud API calls and resource provisioning require network communication and
real infrastructure operations.

It is also more expensive because resources can generate charges even during
short-lived tests. This is especially important in AWS Academy, where students
work with limited credits and account restrictions.

Real AWS tests can also be less reliable because of service availability,
IAM permissions, account policies, quotas and regional limitations.

LocalStack provides a faster and more consistent environment for validating
Terraform configuration without requiring real AWS credentials or creating
billable AWS infrastructure in the CI pipeline.

However, LocalStack does not fully reproduce AWS. A successful LocalStack
test does not guarantee that a deployment to real AWS will succeed.

## CI/CD

The GitHub Actions workflow is located at:

`.github/workflows/lab5-ci.yml`

It performs:

1. Terraform formatting and validation.
2. Terraform plan and apply against LocalStack.
3. Verification of Terraform outputs and the VPC.

No real AWS credentials are required by the pipeline.

## Evidence

The `evidence/` directory stores verification outputs and CI evidence.

## Important

Do not commit Terraform state files, saved plans, or the `.terraform/`
directory.
