The GitHub Actions runner connects to the EC2 instance through AWS Systems Manager (SSM), using temporary AWS credentials and Ansible without opening SSH port 22.
Ansible reporting changed=0 on the second execution demonstrates idempotency because the desired server configuration is already applied and no additional changes are required.
Deregistering a Golden AMI does not automatically delete its associated EBS snapshot, so both the AMI and snapshot must be removed during cleanup to avoid unnecessary storage costs.
