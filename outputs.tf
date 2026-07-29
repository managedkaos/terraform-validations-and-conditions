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
