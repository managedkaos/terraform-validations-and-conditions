# Demo Walkthrough

> [!TIP]
> The following commands use [`bat`](https://github.com/sharkdp/bat) to view files. If you don't have `bat` installed, use `less -N` instead.

## Discussion

Start in the project root.

| # | Discussion topic | Command/Code Snippet |
| --- | ------------------ | --------------------- |
| 1 | Show the files | `ls` |
| 2 | Discuss version pinning | `bat versions.tf` |
| 3 | Discuss module pinning | `bat modules.tf` |
| 5 | Discuss the variables | `bat variables.tf` |
| 6 | Present the root module | `vim main.tf` |
| 7 | Discuss external data sources | `data "external" "echo"` |
| 8 | Discuss `null_resource` | `resource "null_resource" "example"` |
| 9 | Discuss `triggers` | `triggers = { uuid = uuid()` |
| 10| Discuss `precondition` | `condition = var.minimum_replicas <= var.maximum_replicas` |
| 11| Discuss `postcondition` | `condition = self.triggers.environment == var.environment` |
| 12 | Discuss `local-exec` provisioner | `provisioner "local-exec" {` |

## Demonstration

Run the following make commands to demo the code.

| # | Discussion topic | Make target |
| --- | ------------ | -------- |
| 1 | Small, composable, and testable modules | `make plan` |
| 2 | Variable validation | `make validation-invalid-value` |
| 3 | Multiple validation blocks | `make validation-uppercase` |
| 4 | Preconditions | `make precondition-failure` |
| 5 | Postconditions | `make postcondition-success` |
| 6 | Versioned dependencies | `make version`, then `make providers` |
| 7 | Provisioners and `null_resource` | `make apply-valid` |
| 8 | Triggers | `make output-triggers` |

## Additional discussion points

Consider the following points for each [`Makefile`](./Makefile) target.

| # | Discussion topic | Make target |
| --- | ------------ | -------- |
| 1 | Orient the audience to the available demonstrations | `make help` |
| 2 | Initialize Terraform and install the pinned providers and example module | `make init` |
| 3 | Show the installed Terraform core version and selected provider versions | `make version` |
| 4 | Show the provider requirements of the root configuration and its modules | `make providers` |
| 5  | Revisit the `null_resource`, its triggers, and its `local-exec` provisioner during the "Beyond Terraform Modules" discussion | `make apply-valid` |
| 6 | Introduce input variables, module composition, outputs, and the valid baseline configuration | `make plan` |
| 7 | Demonstrate an input validation that restricts a variable to an allowed set of values | `make validation-invalid-value` |
| 8 | Demonstrate multiple validation blocks on the same input variable | `make validation-uppercase` |
| 9 | Demonstrate a precondition that checks the relationship between different input variables | `make precondition-failure` |
| 10 | Apply a valid configuration and demonstrate the guarantee enforced by the resource postcondition | `make postcondition-success` |
| 11 | Inspect the values recorded in the `null_resource` triggers | `make output-triggers` |

## Presentation Notes

- `make init` visibly downloads the example module only when run in a fresh working directory. Terraform does not display the selected module version through `terraform providers`, so show the exact `version = "3.0.1"` line in `modules.tf` during the versioning discussion.

- `make postcondition-success` also executes the `local-exec` provisioner. Briefly acknowledge that output when it first appears, then defer its detailed explanation until the "Beyond Terraform Modules" section.

- The external data source reads the query value from standard input and returns it as output during planning and applying. Use it to close the demo with the warning that provisioners, external data sources, and similar escape hatches reduce portability and should be used conservatively.
