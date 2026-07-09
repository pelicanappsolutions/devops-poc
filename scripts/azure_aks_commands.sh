#!/usr/bin/env bash
set -euo pipefail

cat <<'AZURE'
Azure / AKS command practice.
Do not run these unless you have Azure CLI installed and you are logged in.

Login:
  az login
  az account show

Create resource group:
  az group create --name rg-cgi-devops-practice --location eastus

Create Azure Container Registry:
  az acr create --resource-group rg-cgi-devops-practice --name <uniqueacrname> --sku Basic

Login to ACR:
  az acr login --name <uniqueacrname>

Build and push image:
  docker build -t <uniqueacrname>.azurecr.io/cgi-devops-practice-app:v1 .
  docker push <uniqueacrname>.azurecr.io/cgi-devops-practice-app:v1

Create AKS:
  az aks create \
    --resource-group rg-cgi-devops-practice \
    --name aks-cgi-devops-practice \
    --node-count 1 \
    --enable-managed-identity \
    --attach-acr <uniqueacrname> \
    --generate-ssh-keys

Get kubeconfig:
  az aks get-credentials --resource-group rg-cgi-devops-practice --name aks-cgi-devops-practice

Deploy:
  kubectl apply -f k8s/

Check:
  kubectl get nodes
  kubectl get pods -n cgi-devops-practice
  kubectl logs -n cgi-devops-practice -l app=cgi-devops-practice-app

Clean up:
  az group delete --name rg-cgi-devops-practice --yes --no-wait
AZURE
