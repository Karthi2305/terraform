# Terraform State

Terraform does not directly query the cloud to understand existing resources.
Instead, it relies on a state file (terraform.tfstate).

The state file is the source of truth and is required to:
- Track resource IDs
- Understand dependencies
- Detect changes
- Safely update infrastructure
