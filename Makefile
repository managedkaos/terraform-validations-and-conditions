TF ?= terraform

.PHONY: help init version providers plan apply-valid validation-invalid-value validation-uppercase precondition-failure postcondition-success output-triggers

help: ## Display available targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "\033[36m%-28s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize Terraform configuration
	$(TF) init

version: ## Show the installed Terraform core and provider versions
	$(TF) version

providers: ## Show provider requirements for the configuration
	$(TF) providers

plan: ## Preview the configuration with valid defaults
	$(TF) plan -input=false

apply-valid: ## Apply valid environment and replica values
	$(TF) apply -input=false -auto-approve \
		-var='environment=staging' \
		-var='minimum_replicas=2' \
		-var='maximum_replicas=4'

validation-invalid-value: ## Test rejection of an unsupported environment
	@! $(TF) plan -input=false -var='environment=foobar'

validation-uppercase: ## Test rejection of an uppercase environment
	@! $(TF) plan -input=false -var='environment=Production'

precondition-failure: ## Test rejection of invalid replica limits
	@! $(TF) plan -input=false \
		-var='minimum_replicas=5' \
		-var='maximum_replicas=3'

postcondition-success: ## Apply and pass the resource postcondition
	$(TF) apply -input=false -auto-approve -var='environment=production'

output-triggers: ## Show the current null resource triggers
	$(TF) output null_resource_triggers
