variable "example" {
  type    = string
  default = "Hello, World!"
}

variable "environment" {
  description = "Deployment environment used by the local example."
  type        = string
  default     = "development"

  # A variable can contain multiple validation blocks. Each condition should
  # describe a valid value and must evaluate to true.
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }

  validation {
    condition     = var.environment == lower(var.environment)
    error_message = "Environment must use lowercase letters."
  }
}

variable "minimum_replicas" {
  description = "Minimum number of replicas for the precondition example."
  type        = number
  default     = 1
}

variable "maximum_replicas" {
  description = "Maximum number of replicas for the precondition example."
  type        = number
  default     = 3
}

data "external" "echo" {
  program = ["bash", "-c", "cat /dev/stdin"]
  query = {
    foo = var.example # Was hardcoded to "bar", now using the variable
  }
}

output "echo" {
  value = data.external.echo.result
}
output "echo_foo" {
  value = data.external.echo.result.foo
}

resource "null_resource" "example" {
  # Use UUID to force this null_resource to be recreated on every
  # call to 'terraform apply'
  triggers = {
    uuid        = uuid()
    environment = var.environment
  }

  lifecycle {
    # Unlike an input variable validation, a precondition can compare values
    # from multiple variables and other objects before resource operations.
    precondition {
      condition     = var.minimum_replicas <= var.maximum_replicas
      error_message = "minimum_replicas cannot be greater than maximum_replicas."
    }

    # Postconditions can inspect attributes exported by the surrounding
    # resource through `self`.
    postcondition {
      condition     = self.triggers.environment == var.environment
      error_message = "The resource environment does not match the requested environment."
    }
  }

  provisioner "local-exec" {
    command = "echo \"Hello, World from $(uname -smp)\""
  }
}

# output the null_resource's triggers to verify that it is being recreated

output "null_resource_triggers" {
  value = null_resource.example.triggers
}
