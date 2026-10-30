#!/bin/bash

set -euo pipefail

#Ensure user is logged in to Azure CLI
az account show &> /dev/null || { echo "Please log in using 'az login' first."; exit 1; }

# Prompt the non-technical staff for input
read -p "Enter project name: " ...

if [ -z "$PROJECT_NAME" ]; then
    echo "Error: Project name cannot be empty."
    exit 1
fi

#Set deployment variables
LOCATION="southafricanorth"
RG_NAME="${PROJECT_NAME}-RG"

# Storage account names must be lowercase alphanumeric only (max 24 characters)
CLEAN_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9')
RANDOM_SUFFIX=$((RANDOM % 90000 + 10000))
STORAGE_NAME="${CLEAN_NAME}store${RANDOM_SUFFIX}"
VNET_NAME="${PROJECT_NAME}-vnet"

echo ""
echo "Deploying resources to $LOCATION..."
echo "--------------------------------------------------"

# 1. Create Resource Group
echo "[1/3] Creating Resource Group: $RG_NAME..."
az group create \
    --name "$RG_NAME" \
    --location "$LOCATION" \
    --output none

# 2. Create Storage Account
echo "[2/3] Creating Storage Account: $STORAGE_NAME..."
az storage account create \
    --name "$STORAGE_NAME" \
    --resource-group "$RG_NAME" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --output none

# 3. Create Virtual Network
echo "[3/3] Creating Virtual Network: $VNET_NAME..."
az network vnet create \
    --name "$VNET_NAME" \
    --resource-group "$RG_NAME" \
    --location "$LOCATION" \
    --address-prefix 10.0.0.0/16 \
    --output none

# Display Success Message
echo "=================================================="
echo " SUCCESS: Environment deployed successfully!"
echo "--------------------------------------------------"
echo " Resource Group : $RG_NAME"
echo " Storage Account: $STORAGE_NAME"
echo " Virtual Network: $VNET_NAME"
echo " Location       : $LOCATION"
echo "=================================================="