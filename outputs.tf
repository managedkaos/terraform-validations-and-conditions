output "echo" {
  value = data.external.echo.result
}
output "echo_foo" {
  value = data.external.echo.result.foo
}

# output the null_resource's triggers to verify that it is being recreated

output "null_resource_triggers" {
  value = null_resource.example.triggers
}

output "module_example" {
  description = "Output from the exactly pinned Cloud Posse example module."
  value       = module.example.example
}
