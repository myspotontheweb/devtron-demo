#!/bin/bash

set -euo pipefail
set -x

#
# Variables
#
AZURE_NAME=${AZURE_NAME:-moc-scoil-1}
AZURE_SUBSCRIPTION=${AZURE_SUBSCRIPTION:-$AZURE_NAME}
AZURE_RESOURCE_GROUP=$AZURE_NAME
AZURE_REGION=${AZURE_REGION:-northeurope}
AZURE_REGISTRY=${AZURE_NAME//-/}
AZURE_AKS_CLUSTER=$AZURE_NAME

echo "Creating Resource Group: $AZURE_RESOURCE_GROUP"
az group create --subscription $AZURE_SUBSCRIPTION --name $AZURE_RESOURCE_GROUP --location $AZURE_REGION --tags ephemeral=true

echo "Creating Registry: $AZURE_REGISTRY"
az acr create --subscription $AZURE_SUBSCRIPTION --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_REGISTRY --sku Basic

echo "Creating Cluster: $AZURE_AKS_CLUSTER"
az aks create --subscription $AZURE_SUBSCRIPTION --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER --generate-ssh-keys --enable-cluster-autoscaler --min-count 1 --max-count 5 --enable-aad --enable-azure-rbac --disable-local-accounts --attach-acr $AZURE_REGISTRY

echo "Assigning admin role"
az role assignment create --role "Azure Kubernetes Service RBAC Cluster Admin" --assignee $(az ad signed-in-user show --query id -o tsv) --scope $(az aks show --subscription $AZURE_SUBSCRIPTION --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER --query id -o tsv)

echo "Getting credentials"
az aks get-credentials --subscription $AZURE_SUBSCRIPTION --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER --overwrite-existing
kubelogin convert-kubeconfig -l azurecli

