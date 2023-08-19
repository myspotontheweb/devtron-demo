#!/bin/bash

set -euo pipefail

create_resource_group () {
   echo "Creating Resource Group: $AZURE_RESOURCE_GROUP"
   az group create --subscription $AZURE_SUBSCRIPTION --name $AZURE_RESOURCE_GROUP --location $AZURE_REGION --tags ephemeral=true
}

create_registry () {
   echo "Creating Registry: $AZURE_REGISTRY"
   az acr create --subscription $AZURE_SUBSCRIPTION --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_REGISTRY --sku Basic
}

create_cluster () {
   echo "Creating Cluster: $AZURE_AKS_CLUSTER"
   az aks create --subscription $AZURE_SUBSCRIPTION --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER --generate-ssh-keys --enable-cluster-autoscaler --min-count 1 --max-count 5 --enable-aad --enable-azure-rbac --disable-local-accounts --attach-acr $AZURE_REGISTRY
}

assign_admin_role () {
   echo "Assigning admin role"
   az role assignment create --role "Azure Kubernetes Service RBAC Cluster Admin" --assignee $(az ad signed-in-user show --query id -o tsv) --scope $(az aks show --subscription $AZURE_SUBSCRIPTION --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER --query id -o tsv)
}

get_creds () {
   echo "Getting credentials"
   az aks get-credentials --subscription $AZURE_SUBSCRIPTION --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER --overwrite-existing
   kubelogin convert-kubeconfig -l azurecli
}

#
# Variables
#
NAME=${NAME:-moc-scoil-1}

AZURE_SUBSCRIPTION=${AZURE_SUBSCRIPTION:-$NAME}
AZURE_RESOURCE_GROUP=$NAME
AZURE_REGION=${AZURE_REGION:-northeurope}
AZURE_REGISTRY=${NAME//-/}
AZURE_AKS_CLUSTER=$NAME

#
# Main program
#
create_resource_group
create_registry
create_cluster
assign_admin_role
get_creds
