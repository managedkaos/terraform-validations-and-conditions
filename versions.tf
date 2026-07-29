terraform {
  required_version = ">= 1.14, < 2.0.0"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "= 2.4.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "= 3.3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "= 3.9.0"
    }
  }
}
