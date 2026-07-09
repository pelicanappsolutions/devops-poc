#!/usr/bin/env bash
set -euo pipefail

cat <<'AZURE'
Azure / AKS command practice.
Do not run these unless you have Azure CLI installed and you are logged in.

Login:
  az login
  az account show

Create resource group:
  az group create --name rg-devops-poc --location eastus

Create Azure Container Registry:
  az acr create --resource-group rg-devops-poc --name <uniqueacrname> --sku Basic

Login to ACR:
  az acr login --name <uniqueacrname>

Build and push image:
  docker build -t <uniqueacrname>.azurecr.io/devops-poc-app:v1 .
  docker push <uniqueacrname>.azurecr.io/devops-poc-app:v1

Create AKS:
  az aks create \
    --resource-group rg-devops-poc \
    --name aks-devops-poc \
    --node-count 1 \
    --enable-managed-identity \
    --attach-acr <uniqueacrname> \
    --generate-ssh-keys

Get kubeconfig:
  az aks get-credentials --resource-group rg-devops-poc --name aks-devops-poc

Deploy:
  kubectl apply -f k8s/

Check:
  kubectl get nodes
  kubectl get pods -n devops-poc
  kubectl logs -n devops-poc -l app=devops-poc-app

Clean up:
  az group delete --name rg-devops-poc --yes --no-wait
AZURE
