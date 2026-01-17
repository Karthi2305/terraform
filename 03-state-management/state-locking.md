# State Locking

State locking ensures that only one Terraform operation modifies the state at a time.

Without locking:
- Duplicate resources may be created
- State corruption can occur

With remote state + locking:
- Terraform checks lock backend (e.g., DynamoDB)
- Applies changes safely
- Releases lock after completion
