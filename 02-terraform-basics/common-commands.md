# Common Terraform Commands

This document covers commonly used Terraform commands along with
their purpose and real-world use cases.

---
```bash
terraform init
```

Initializes a Terraform working directory by downloading required
providers, modules, and configuring the backend.

### When to use
- First time working in a directory
- After adding or changing providers
- After configuring or modifying backend

### Real-world use case
Before running any Terraform operation in a new project or after
cloning a repository, `terraform init` must be executed.

---
```bash
terraform plan
```
Creates an execution plan showing what Terraform will create, update,
or destroy without making actual changes.

### When to use
- Before applying changes
- To review infrastructure impact
- During code review or approval process

### Real-world use case
Used in CI/CD pipelines to validate infrastructure changes before
approval.

---
```bash
terraform apply
```
Applies the planned changes to the infrastructure and updates
the Terraform state.

### When to use
- To provision or update infrastructure
- After reviewing `terraform plan`

### Real-world use case
Used during deployments to create or update cloud resources.

---
```bash
terraform destroy
```
Destroys all resources managed by the current Terraform configuration.

### When to use
- Cleaning up test environments
- Decommissioning infrastructure

### Real-world use case
Used to delete non-production environments to save cost.

---
```bash
terraform show
```
Displays the current state or a saved plan in human-readable format.

### When to use
- To inspect current infrastructure state
- For debugging

---
```bash
terraform force-unlock <LOCK_ID>
```
Manually removes a stale state lock.

### When to use
- When a previous Terraform process crashed
- When a lock was not released properly

### ⚠️ Warning
Use only when you are sure no other Terraform operation is running.

---
```bash
terraform state list
```
Lists all resources tracked in the Terraform state file.

### When to use
- To inspect managed resources
- Before refactoring or import

---
```bash
terraform state show <RESOURCE>
```

Shows detailed information about a specific resource from the state.

### When to use
- Debugging resource attributes
- Verifying imported resources

---
```bash
terraform state rm <RESOURCE>
```

Removes a resource from state without deleting it from the cloud.

### When to use
- When Terraform should stop managing a resource

### Real-world use case
Used when resources are moved outside Terraform management.

---
```bash
terraform state mv
```

Moves resources within state.

### When to use
- Refactoring resources into modules
- Renaming resources safely

---
```bash
terraform init -upgrade
```
Reinitializes Terraform and upgrades providers and modules.

### When to use
- After changing version constraints
- To pull latest compatible provider versions

---
```bash
terraform workspace new <NAME>
```
Creates a new workspace with isolated state.

### When to use
- Creating new environments (dev, qa, prod)

---
```bash
terraform workspace list
```
Lists all available workspaces.

---
```bash
terraform workspace select <NAME>
```
Switches to a specific workspace.

---
```bash
terraform workspace show
```
Displays the currently active workspace.

---
```bash
terraform graph | dot -Tsvg > graph.svg
```
Generates a visual dependency graph of Terraform resources.

### When to use
- Understanding complex infrastructure dependencies
- Debugging creation order
