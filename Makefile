FILE := docker-example.pkr.hcl

ifndef VERBOSE
.SILENT:
endif

##: ## Set VERBOSE=1 to echo commands while running

.PHONY: help build all init

help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[#a-zA-Z_/-]+:.*?## .*$$' | sort -V | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build docker image
	packer build $(FILE)

all: init build ## Initialize packer and build

init: ## Initialize packer (install plugins)
	packer init $(FILE)