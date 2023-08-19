#!/bin/bash

set -euo pipefail
set -x

#
# Variables
#
AZURE_NAME=${AZURE_NAME:-moc-scoil-1}
AZURE_SUBSCRIPTION=${AZURE_SUBSCRIPTION:-$AZURE_NAME}
AZURE_RESOURCE_GROUP=$AZURE_NAME

echo "Deleting Resource Group: $AZURE_RESOURCE_GROUP"
az group delete --subscription $AZURE_SUBSCRIPTION --name $AZURE_RESOURCE_GROUP 

