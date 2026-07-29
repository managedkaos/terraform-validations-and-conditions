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
