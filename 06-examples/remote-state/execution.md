# Remote State – Terraform Execution Guide

This example demonstrates how Terraform uses a **remote backend (S3)**
with **state locking (DynamoDB)** and why the configuration is split
across multiple `.tf` files.

---

## Why the Terraform files are separated

Although Terraform allows all configuration in a single file,
this project follows **production best practices** by separating concerns.

Each `.tf` file has a specific responsibility:

### backend.tf
- Configures **remote state storage** in Amazon S3
- Enables **state locking** using DynamoDB
- Prevents concurrent `terraform apply` conflicts

### provider.tf
- Defines Terraform and provider versions
- Configures the AWS provider and region

### vpc.tf
- Creates networking components:
  - VPC
  - Internet Gateway
  - Public Subnet
  - Route Table and association

### security-group.tf
- Defines security group rules
- Allows:
  - SSH (22)
  - HTTP (80)

### ec2.tf
- Fetches the latest Amazon Linux 2 AMI
- Creates an EC2 instance
- Installs Apache using `user_data`

### outputs.tf
- Exposes useful information:
  - EC2 public IP
  - Instance ID
  - VPC ID
  - Website URL

> Terraform automatically loads all `.tf` files in this directory
> and builds a single execution plan.

---

## Prerequisites

Before executing this example:

- Terraform installed
- AWS CLI installed
- AWS credentials configured
  ```bash
  aws configure
```
S3 bucket need to be created
```bash
aws s3 mb s3://<BUCKET-NAME --region <REGION>

aws s3api put-bucket-versioning   --bucket shopfast-terraform-state   --versioning-configuration Status=Enabled
```
Enable versioning

### Create DynamoDB Table for State Locking

```bash
aws dynamodb create-table \
  --table-name terraform-state-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region <region>
```

This table is used by Terraform to lock the state file
and prevent concurrent terraform apply operations.

Verify DynamoDB Table Status
```bash
aws dynamodb describe-table \
  --table-name terraform-state-locks \
  --region ap-south-1 | grep TableStatus
```
Expected output:

TableStatus: ACTIVE

### Step 1: Initialize Terraform
```bash
terraform init
```
What happens:

- Downloads AWS provider
- Configures S3 remote backend
- Enables DynamoDB locking
- Creates .terraform/ directory
---

### Step 2: Review the Execution Plan
```bash
terraform plan
```
What happens:
- Shows resources to be created
- Reads remote state (if exists)
- Makes no changes to AWS
---

### Step 3: Apply the Configuration
```bash
terraform apply
```
What happens:

- Creates VPC and networking
- Creates security group
- Launches EC2 instance
- Stores state in S3
- Locks state using DynamoDB

Files Generated Locally
After execution:

- .terraform/ → Provider cache
- .terraform.lock.hcl → Provider version lock

❗ No terraform.tfstate is stored locally
State is stored securely in S3.
---

### Verification
- Check EC2 instance in AWS Console
- Access the web server using the output URL
- Verify state file exists in S3 bucket
- Verify lock entry in DynamoDB during apply
---

### Cleanup
To destroy all resources:
```bash
terraform destroy
```

This removes infrastructure and updates the remote state
---

### Delete BUCKET
```bash
aws s3 rb s3://<bucket-name> --force
```
---

### Delect DynamoDB

After destroying all Terraform-managed resources,
you can delete the DynamoDB table used for state locking.

```bash
aws dynamodb delete-table \
  --table-name terraform-state-locks \
  --region ap-south-1
```
This removes the DynamoDB table that was used
to prevent concurrent Terraform operations.
---
