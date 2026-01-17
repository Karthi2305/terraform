# Terraform Resource Graph

Terraform builds a dependency graph internally to determine the correct
order of resource creation and deletion.

Generate a visual graph using:
```bash
terraform graph | dot -Tsvg > graph.svg

### Graphviz must be installed to convert the output.
