# terraform-validations-and-conditions

An example showing how to apply validations, preconditions, and postconditions in Terraform.

## Overview

This project demonstrates three Terraform mechanisms for enforcing constraints on your infrastructure configuration:

- **Variable Validations** – enforce constraints on input variables before any plan or apply is attempted.
- **Preconditions** – check relationships between multiple variables or objects before a resource operation begins.
- **Postconditions** – verify resource attributes after creation to ensure they match the intended state.

## Configuration

### Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `example` | `string` | `"Hello, World!"` | A generic string passed to the external data source. |
| `environment` | `string` | `"development"` | Deployment environment. Must be one of `development`, `staging`, or `production`, and must be lowercase. |
| `minimum_replicas` | `number` | `1` | Minimum number of replicas (used in the precondition example). |
| `maximum_replicas` | `number` | `3` | Maximum number of replicas (used in the precondition example). |

### Validation Examples

The `environment` variable includes two `validation` blocks:

1. **Allowed values** – rejects any value not in `["development", "staging", "production"]`.
2. **Lowercase enforcement** – rejects values that contain uppercase letters (e.g., `Production`).

```hcl
validation {
  condition     = contains(["development", "staging", "production"], var.environment)
  error_message = "Environment must be development, staging, or production."
}

validation {
  condition     = var.environment == lower(var.environment)
  error_message = "Environment must use lowercase letters."
}
```

### Precondition Example

The `null_resource.example` lifecycle block includes a precondition that compares two variables — something a simple variable validation cannot do:

```hcl
precondition {
  condition     = var.minimum_replicas <= var.maximum_replicas
  error_message = "minimum_replicas cannot be greater than maximum_replicas."
}
```

### Postcondition Example

A postcondition inspects the resource's own exported attributes via `self` after creation:

```hcl
postcondition {
  condition     = self.triggers.environment == var.environment
  error_message = "The resource environment does not match the requested environment."
}
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.2 (preconditions/postconditions require Terraform 1.2+)
- `bash` and standard Unix utilities (used by the external data source)
- `make`

## Usage

Initialize the Terraform working directory:

```bash
terraform init
```

Use the `Makefile` targets to exercise the various validation scenarios:

```bash
make help
```

### Available Targets

| Target | Description |
|--------|-------------|
| `plan` | Preview the configuration with valid defaults |
| `apply-valid` | Apply valid `environment` and replica values |
| `validation-invalid-value` | Test rejection of an unsupported environment (e.g., `foobar`) |
| `validation-uppercase` | Test rejection of an uppercase environment (e.g., `Production`) |
| `precondition-failure` | Test rejection of invalid replica limits (`minimum > maximum`) |
| `postcondition-success` | Apply with a valid environment and verify the postcondition passes |
| `output-triggers` | Show the current `null_resource` triggers output |

### Examples

```bash
# Preview with default values
make plan

# Apply with valid overrides
make apply-valid

# Confirm that an invalid environment is rejected
make validation-invalid-value

# Confirm that an uppercase environment is rejected
make validation-uppercase

# Confirm that minimum_replicas > maximum_replicas is rejected
make precondition-failure

# Apply and verify the postcondition passes
make postcondition-success
```

## Outputs

| Name | Description |
|------|-------------|
| `echo` | Full result map from the external data source |
| `echo_foo` | The `foo` key from the external data source result |
| `null_resource_triggers` | The `triggers` map of the null resource, useful for verifying recreation on every apply |

## License

See [LICENSE](LICENSE).
