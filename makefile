.DEFAULT_GOAL:=help

.PHONY: help deps clean build watch

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

lint: ## Lint yaml files
	yamllint .

test_all: ## Run molecule tests
	molecule test --all

test_centos: ## Run molecule centos tests
	molecule test --scenario-name centos

test_debian: ## Run molecule debian tests
	molecule test --scenario-name debian

test_ubuntu: ## Run molecule ubuntu tests
	molecule test --scenario-name ubuntu
