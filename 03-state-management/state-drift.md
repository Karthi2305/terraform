# State Drift

State drift occurs when infrastructure is modified outside Terraform
(e.g., via cloud console or CLI).

Terraform detects drift by comparing:
- Desired state (.tf files)
- Actual cloud resources
- Stored state file

Drift is identified using:
```bash
terraform plan
