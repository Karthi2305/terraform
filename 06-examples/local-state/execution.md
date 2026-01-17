# Local State EC2 – Execution Guide

This example demonstrates how Terraform uses **local state**
to provision AWS infrastructure.

---

## What this Terraform configuration creates

Running this configuration will create the following AWS resources:

- An EC2 instance (Ubuntu)
- A security group
  - Allows SSH access on port 22
- AWS-managed networking (default VPC)

Terraform tracks all created resources using a **local state file**
stored in the working directory.

---

## Prerequisites

Before running this example, ensure:

- Terraform is installed
- AWS CLI is installed
- AWS credentials are configured using `aws configure`
- You have permission to create EC2 and Security Groups

---

## Execution Steps

### Step 1: Initialize Terraform
```bash
terraform init
```

this Downloads required provider plugins and initializes the working directory.

### Step 2: Review execution plan
```bash
terraform plan
```
## Shows what resources Terraform will create without applying changes.

### Step 3: Apply the configuration
```bash
terraform apply
```

this will Creates the infrastructure after confirmation. (typing YES)


## Files Generated During Execution (Local Only)

- .terraform/ 			– provider and module cache
- terraform.tfstate 		- current infrastructure state
- terraform.tfstate.backup	- backup of previous state


### Verification

After apply:

Check EC2 instance in AWS Console

Use the output values to confirm instance creation

### Cleanup

To destroy all created resources:
```bash
terraform destroy
```

This removes the infrastructure and updates the local state accordingly.
