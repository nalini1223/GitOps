# ============================================================
# Golden Path Platform - Standardized Automation Entry Points
# ============================================================

APP_NAME      := golden-path-app
IMAGE_TAG      := latest
K8S_NAMESPACE := argocd
TERRAFORM_DIR := terraform
K8S_DIR        := k8s

.PHONY: help build deploy-platform deploy-app verify status clean

## Show available commands
help:
	@echo ""
	@echo "Golden Path Platform - Available Commands"
	@echo "---------------------------------------"
	@echo "make build            Build application container image"
	@echo "make deploy-platform  Install GitOps platform (Argo CD)"
	@echo "make deploy-app       Apply application manifests"
	@echo "make verify           Verify application health"
	@echo "make status           View platform and app status"
	@echo "make clean            Remove platform resources"
	@echo ""

## Build the application container image
build:
	docker build -t $(APP_NAME):$(IMAGE_TAG) ./app

## Deploy GitOps platform components (Argo CD via Terraform)
deploy-platform:
		cd $(TERRAFORM_DIR) && terraform init && terraform apply

## Deploy application (GitOps controller reconciles state)
deploy-app:
	kubectl apply -f $(K8S_DIR)

## Verify application and platform health
verify:
	kubectl get pods -n $(K8S_NAMESPACE)
	kubectl get svc -n $(K8S_NAMESPACE)
	kubectl get ingress -n $(K8S_NAMESPACE)

## View high-level status
status:
	kubectl get applications -n argocd || true
	kubectl get pods -A

## Cleanup platform resources (local use only)
clean:
	cd $(TERRAFORM_DIR) && terraform destroy
