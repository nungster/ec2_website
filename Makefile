#!make

# Usage:
# make help

## Variables
TF_VARS = ./variables.tfvars

## TARGETS
.PHONY: default
default: help ;

.PHONY: clean
clean:
	rm -rf .terraform plan.out plan.log
	docker-compose rm -f
	docker-compose down --rmi all

.PHONY: build
build:
	docker-compose build

.PHONY: push
push:
	docker build --platform=linux/amd64 -t nungster/ec2_website:latest .

.PHONY: up
up:
	docker-compose up

.ONESHELL:

.PHONY: init
init: clean
	@echo "\n## Initializing Terraform\n"
	cd terraform && terraform init -reconfigure

.PHONY: validate
validate:
	@echo "\n## Terraform Validate\n"
	cd terraform && terraform validate

.PHONY: plan
plan: init validate
	@echo "\n## Terraform Plan\n"
	cd terraform && terraform plan -no-color -out=plan.out \
	-var-file=$(TF_VARS) | tee plan.log

.ONESHELL:
.PHONY: apply
apply: plan
	@echo "\n## Terraform Apply\n"
	grep -q 'No changes. Your infrastructure matches the configuration.' plan.log || \
		cd terraform && terraform apply -parallelism=1 -auto-approve plan.out

.PHONY: destroy
destroy: init
	@echo "\n## Terraform Destroy\n"
	cd terraform && terraform destroy -var-file=$(TF_VARS)

## USAGE
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo "  clean             Remove terraform work files, Docker containers and images "
	@echo "  build             Build the Python Django Website using Docker Compose "
	@echo "  push							 Tag and push image to repository"
	@echo "  up                Start the website locally via Docker Compose"
	@echo "  init              Initialize terraform environment"
	@echo "  plan              Execute Terraform Plan (see which resources is Terraform going to create/update)"
	@echo "  apply             Execute Terraform Apply to build and run the website in the region specified in the terraform/variables.tfvars file"
	@echo "  destroy           Execute Terraform Force Destroy"
