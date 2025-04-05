# Colors for better visibility
BLUE := \033[36m
NC := \033[0m  # No Color

.PHONY: zip-lambda
zip-lambda: ## Zip the lambda function
	cd email_api && npm install && zip -r email_api.zip index.js node_modules

.PHONY: format
format: ## Run code formatters
	terraform fmt

.PHONY: check
check: ## Run code quality checks
	terraform fmt -check -recursive
	terraform validate

.PHONY: help
help: ## Display available commands with descriptions
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"; printf "\n"} \
		/^[a-zA-Z_-]+:.*?##/ { printf "  ${BLUE}%-15s${NC} %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)
	@echo ""

# Default target when running just 'make'
.DEFAULT_GOAL := help
