#!/bin/bash

set -euo pipefail

delete_resource_group () {
   echo "Deleting Resource Group: $AZURE_RESOURCE_GROUP"
   az group delete --subscription $AZURE_SUBSCRIPTION --name $AZURE_RESOURCE_GROUP 
}

#
# Variables
#
NAME=${NAME:-moc-scoil-1}

AZURE_SUBSCRIPTION=${AZURE_SUBSCRIPTION:-$NAME}
AZURE_RESOURCE_GROUP=$NAME

#
# Main program
#
delete_resource_group
