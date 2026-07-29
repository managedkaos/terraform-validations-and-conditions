# Demo Walkthrough

Use the targets in this order to follow the chapter discussion from
production-grade modules through Terraform escape hatches.

## Target Order

1. `make help`
   - Orient the audience to the available demonstrations.
2. `make init`
   - Initialize Terraform and install the pinned providers and example module.
3. `make plan`
   - Introduce input variables, module composition, outputs, and the valid
     baseline configuration.
4. `make validation-invalid-value`
   - Demonstrate an input validation that restricts a variable to an allowed
     set of values.
5. `make validation-uppercase`
   - Demonstrate multiple validation blocks on the same input variable.
6. `make precondition-failure`
   - Demonstrate a precondition that checks the relationship between different
     input variables.
7. `make postcondition-success`
   - Apply a valid configuration and demonstrate the guarantee enforced by the
     resource postcondition.
8. `make version`
   - Show the installed Terraform core version and selected provider versions.
9. `make providers`
   - Show the provider requirements of the root configuration and its modules.
10. `make apply-valid`
    - Revisit the `null_resource`, its triggers, and its `local-exec`
      provisioner during the "Beyond Terraform Modules" discussion.
11. `make output-triggers`
    - Inspect the values recorded in the `null_resource` triggers.

## Chapter Sequence

| Discussion | Target |
|------------|--------|
| Small, composable, and testable modules | `make plan` |
| Variable validation | `make validation-invalid-value` |
| Multiple validation blocks | `make validation-uppercase` |
| Preconditions | `make precondition-failure` |
| Postconditions | `make postcondition-success` |
| Versioned dependencies | `make version`, then `make providers` |
| Provisioners and `null_resource` | `make apply-valid` |
| Triggers | `make output-triggers` |

## Presentation Notes

- `make init` visibly downloads the example module only when run in a fresh
  working directory. Terraform does not display the selected module version
  through `terraform providers`, so show the exact `version = "3.0.1"` line in
  `modules.tf` during the versioning discussion.
- `make postcondition-success` also executes the `local-exec` provisioner.
  Briefly acknowledge that output when it first appears, then defer its detailed
  explanation until the "Beyond Terraform Modules" section.
- The external data source reads the query value from standard input and returns
  it as output during planning and applying. Use it to close the demo with the
  warning that provisioners, external data sources, and similar escape hatches
  reduce portability and should be used conservatively.
