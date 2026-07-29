data "external" "echo" {
  program = ["bash", "-c", "cat /dev/stdin"]
  query = {
    foo = var.example # Was hardcoded to "bar", now using the variable
  }
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
