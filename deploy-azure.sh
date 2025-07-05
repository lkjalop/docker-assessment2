#!/bin/bash

# Azure Deployment Script for Linux/macOS
# This script automates the deployment of the Docker container to Azure
# Student: Leomark Jalop (leomark.jalop@studytafensw.edu.au)

# Set variables - customized for student account
RESOURCE_GROUP_NAME="rg-docker-assessment-leomark"
LOCATION="eastus"
APP_SERVICE_PLAN_NAME="asp-leomark-docker"
WEB_APP_NAME="mvc-app-leomark-jalop"
ACR_NAME="acrleomarkjalop"
IMAGE_NAME="mvc-app"
STUDENT_EMAIL="leomark.jalop@studytafensw.edu.au"

echo "Starting Azure deployment process for student: $STUDENT_EMAIL"
echo "=================================================="

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Azure CLI is not installed. Please install it first."
    exit 1
fi

# Login to Azure with student account
echo "Logging in to Azure with student account..."
echo "Please use email: $STUDENT_EMAIL"
az login --use-device-code

# Create Resource Group
echo "Creating Resource Group: $RESOURCE_GROUP_NAME"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create Azure Container Registry
echo "Creating Azure Container Registry: $ACR_NAME"
az acr create --resource-group $RESOURCE_GROUP_NAME --name $ACR_NAME --sku Basic --location $LOCATION

# Login to ACR
echo "Logging in to Azure Container Registry..."
az acr login --name $ACR_NAME

# Build and push Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME:latest .

# Tag and push image
ACR_LOGIN_SERVER="$ACR_NAME.azurecr.io"
docker tag $IMAGE_NAME:latest $ACR_LOGIN_SERVER/$IMAGE_NAME:latest

echo "Pushing Docker image to ACR..."
docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:latest

# Create App Service Plan
echo "Creating App Service Plan: $APP_SERVICE_PLAN_NAME"
az appservice plan create \
    --name $APP_SERVICE_PLAN_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --sku B1 \
    --is-linux

# Create Web App
echo "Creating Web App: $WEB_APP_NAME"
az webapp create \
    --resource-group $RESOURCE_GROUP_NAME \
    --plan $APP_SERVICE_PLAN_NAME \
    --name $WEB_APP_NAME \
    --deployment-container-image-name $ACR_LOGIN_SERVER/$IMAGE_NAME:latest

# Configure Web App to use ACR
echo "Configuring Web App to use ACR..."
az webapp config container set \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --container-image-name $ACR_LOGIN_SERVER/$IMAGE_NAME:latest \
    --container-registry-url https://$ACR_LOGIN_SERVER

# Get Web App URL
WEB_APP_URL=$(az webapp show --resource-group $RESOURCE_GROUP_NAME --name $WEB_APP_NAME --query "defaultHostName" --output tsv)

echo ""
echo "=== DEPLOYMENT COMPLETED SUCCESSFULLY ==="
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION"
echo "Container Registry: $ACR_LOGIN_SERVER"
echo "App Service Plan: $APP_SERVICE_PLAN_NAME"
echo "Web App Name: $WEB_APP_NAME"
echo "Web App URL: https://$WEB_APP_URL"
echo "=========================================="
echo ""
echo "You can now access your application at: https://$WEB_APP_URL"
echo "API Health Check: https://$WEB_APP_URL/api/api/health"
echo "Swagger Documentation: https://$WEB_APP_URL/swagger"
