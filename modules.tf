# Registry modules support an explicit version argument. Keeping this exact
# prevents a future terraform init from silently selecting a newer release.
module "example" {
  source  = "cloudposse/module/example"
  version = "3.0.1"

  example     = var.example
  namespace   = "demo"
  environment = var.environment
  name        = "validations"
}
