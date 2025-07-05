# Azure Deployment Script
# This script automates the deployment of the Docker container to Azure
# Student: Leomark Jalop (leomark.jalop@studytafensw.edu.au)

param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "rg-docker-assessment-leomark",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "East US",
    
    [Parameter(Mandatory=$false)]
    [string]$AppServicePlanName = "asp-leomark-docker",
    
    [Parameter(Mandatory=$false)]
    [string]$WebAppName = "mvc-app-leomark-jalop",
    
    [Parameter(Mandatory=$false)]
    [string]$ACRName = "acrleomarkjalop",
    
    [Parameter(Mandatory=$false)]
    [string]$ImageName = "mvc-app",
    
    [Parameter(Mandatory=$false)]
    [string]$StudentEmail = "leomark.jalop@studytafensw.edu.au"
)

Write-Host "Starting Azure deployment process for student: $StudentEmail" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green

# Login to Azure (if not already logged in)
Write-Host "Checking Azure login status for student account..." -ForegroundColor Yellow
Write-Host "Student Email: $StudentEmail" -ForegroundColor Cyan
try {
    $context = Get-AzContext
    if ($null -eq $context) {
        Write-Host "Please login to Azure with your student account: $StudentEmail" -ForegroundColor Yellow
        Connect-AzAccount -UseDeviceAuthentication
    }
} catch {
    Write-Host "Please login to Azure with your student account: $StudentEmail" -ForegroundColor Yellow
    Connect-AzAccount -UseDeviceAuthentication
}

# Create Resource Group
Write-Host "Creating Resource Group: $ResourceGroupName" -ForegroundColor Yellow
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if ($null -eq $rg) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location
    Write-Host "Resource Group created successfully" -ForegroundColor Green
} else {
    Write-Host "Resource Group already exists" -ForegroundColor Yellow
}

# Create Azure Container Registry
Write-Host "Creating Azure Container Registry: $ACRName" -ForegroundColor Yellow
$acr = Get-AzContainerRegistry -ResourceGroupName $ResourceGroupName -Name $ACRName -ErrorAction SilentlyContinue
if ($null -eq $acr) {
    New-AzContainerRegistry -ResourceGroupName $ResourceGroupName -Name $ACRName -Location $Location -Sku Basic
    Write-Host "Azure Container Registry created successfully" -ForegroundColor Green
} else {
    Write-Host "Azure Container Registry already exists" -ForegroundColor Yellow
}

# Build and push Docker image
Write-Host "Building and pushing Docker image..." -ForegroundColor Yellow
$acrLoginServer = "$ACRName.azurecr.io"

# Login to ACR
az acr login --name $ACRName

# Build and tag image
docker build -t "$ImageName`:latest" .
docker tag "$ImageName`:latest" "$acrLoginServer/$ImageName`:latest"

# Push image
docker push "$acrLoginServer/$ImageName`:latest"
Write-Host "Docker image pushed successfully" -ForegroundColor Green

# Create App Service Plan
Write-Host "Creating App Service Plan: $AppServicePlanName" -ForegroundColor Yellow
$plan = Get-AzAppServicePlan -ResourceGroupName $ResourceGroupName -Name $AppServicePlanName -ErrorAction SilentlyContinue
if ($null -eq $plan) {
    New-AzAppServicePlan -ResourceGroupName $ResourceGroupName -Name $AppServicePlanName -Location $Location -Tier "B1" -NumberofWorkers 1 -WorkerSize "Small" -Linux
    Write-Host "App Service Plan created successfully" -ForegroundColor Green
} else {
    Write-Host "App Service Plan already exists" -ForegroundColor Yellow
}

# Create Web App
Write-Host "Creating Web App: $WebAppName" -ForegroundColor Yellow
$app = Get-AzWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName -ErrorAction SilentlyContinue
if ($null -eq $app) {
    New-AzWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName -AppServicePlan $AppServicePlanName -ContainerImageName "$acrLoginServer/$ImageName`:latest"
    Write-Host "Web App created successfully" -ForegroundColor Green
} else {
    Write-Host "Web App already exists, updating container image..." -ForegroundColor Yellow
    Set-AzWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName -ContainerImageName "$acrLoginServer/$ImageName`:latest"
}

# Configure Web App settings
Write-Host "Configuring Web App settings..." -ForegroundColor Yellow
$appSettings = @{
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL" = "https://$acrLoginServer"
    "DOCKER_REGISTRY_SERVER_USERNAME" = $ACRName
}

# Get ACR password
$acrCredentials = Get-AzContainerRegistryCredential -ResourceGroupName $ResourceGroupName -Name $ACRName
$appSettings["DOCKER_REGISTRY_SERVER_PASSWORD"] = $acrCredentials.Password

Set-AzWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName -AppSettings $appSettings

# Get Web App URL
$webApp = Get-AzWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName
$webAppUrl = "https://$($webApp.DefaultHostName)"

Write-Host "Deployment completed successfully!" -ForegroundColor Green
Write-Host "Web App URL: $webAppUrl" -ForegroundColor Cyan
Write-Host "Container Registry: $acrLoginServer" -ForegroundColor Cyan

# Output summary
Write-Host "`n=== DEPLOYMENT SUMMARY ===" -ForegroundColor Magenta
Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor White
Write-Host "Location: $Location" -ForegroundColor White
Write-Host "Container Registry: $acrLoginServer" -ForegroundColor White
Write-Host "App Service Plan: $AppServicePlanName" -ForegroundColor White
Write-Host "Web App Name: $WebAppName" -ForegroundColor White
Write-Host "Web App URL: $webAppUrl" -ForegroundColor White
Write-Host "=========================" -ForegroundColor Magenta
