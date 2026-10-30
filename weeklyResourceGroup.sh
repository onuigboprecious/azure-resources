#!/bin/bash 

# create a weekly resources group for various environment  : "Dev, Test, UAT and Prod"

 
set -euo pipefail

 if [ -z "$1" ]; then
    echo "Error: resource name is required."
    echo "Usage: ./weeklyResourceGroup.sh <resource-Group-Name> [Location]"
    exit 1
fi

#resource varriables for deployment.
#southafricanorth is my default Location ...
#because i'm using a free azure account, 
#if users does not specify a 'Location' southafricanorth will be the default location

RESOURCE_NAME=$1
LOCATION=${2:-"southafricanorth"} 
ENVIRONMENTS=("Dev" "Test" "UAT" "Prod")

echo "Creating Resource Groups for Project: $RESOURCE_NAME"
echo "Location: $LOCATION"

for ENV in "${ENVIRONMENTS[@]}"; do
    RG_NAME="${RESOURCE_NAME}-${ENV}-RG"
    echo "Creating resource group: $RG_NAME..."
    
    az group create \
        --name "$RG_NAME" \
        --location "$LOCATION" \
        --output table
done

echo "All resource groups for '$RESOURCE_NAME' created successfully!"
