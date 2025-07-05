# Docker Assessment - Student Instructions
## Leomark Jalop (leomark.jalop@studytafensw.edu.au)

### IMPORTANT: Azure Student Account Setup

Before starting the assessment, ensure you have:
1. **Azure Student Account**: leomark.jalop@studytafensw.edu.au
2. **Azure Student Subscription**: Verify you have access to Azure services
3. **GitHub Account**: Create if you don't have one
4. **Development Environment**: Visual Studio Code or Visual Studio 2022

---

## Step 1: Install Azure CLI

Since Azure CLI is not installed, run the setup script:

```bash
# Make the script executable
chmod +x setup-azure-cli.sh

# Run the installation script
./setup-azure-cli.sh
```

**Alternative Manual Installation:**

### For Ubuntu/Debian:
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### For macOS:
```bash
brew install azure-cli
```

### For Windows:
Download from: https://aka.ms/installazurecliwindows

---

## Step 2: Login to Azure

After installing Azure CLI:

```bash
# Login with device code (recommended for student accounts)
az login --use-device-code
```

**Important**: Use your student email: `leomark.jalop@studytafensw.edu.au`

---

## Step 3: Verify Azure Access

```bash
# Check your subscription
az account show

# List available subscriptions
az account list --output table

# If you have multiple subscriptions, set the student one as default
az account set --subscription "Azure for Students"
```

---

## Step 4: Build and Test Application

```bash
# Restore dependencies
dotnet restore

# Build the application
dotnet build

# Run locally (test before Docker)
dotnet run
```

Visit: http://localhost:5000 or https://localhost:5001

---

## Step 5: Create Docker Image

```bash
# Build Docker image
docker build -t mvc-app .

# Test Docker container locally
docker run -p 8080:8080 mvc-app
```

Visit: http://localhost:8080

---

## Step 6: Deploy to Azure

### Option A: Using the automated script
```bash
./deploy-azure.sh
```

### Option B: Manual deployment
```bash
# Create resource group
az group create --name rg-docker-assessment-leomark --location eastus

# Create Azure Container Registry
az acr create --resource-group rg-docker-assessment-leomark --name acrleomarkjalop --sku Basic

# Login to ACR
az acr login --name acrleomarkjalop

# Tag and push image
docker tag mvc-app acrleomarkjalop.azurecr.io/mvc-app:latest
docker push acrleomarkjalop.azurecr.io/mvc-app:latest

# Create App Service Plan
az appservice plan create --name asp-leomark-docker --resource-group rg-docker-assessment-leomark --sku B1 --is-linux

# Create Web App
az webapp create --resource-group rg-docker-assessment-leomark --plan asp-leomark-docker --name mvc-app-leomark-jalop --deployment-container-image-name acrleomarkjalop.azurecr.io/mvc-app:latest
```

---

## Step 7: Verify Deployment

Your application will be available at:
- **Web App URL**: https://mvc-app-leomark-jalop.azurewebsites.net
- **Health Check**: https://mvc-app-leomark-jalop.azurewebsites.net/api/api/health
- **API Documentation**: https://mvc-app-leomark-jalop.azurewebsites.net/swagger

---

## Assessment Deliverables

Submit the following to your instructor:

### 1. GitHub Repository URL
- Create a GitHub repository for your project
- Push all code to the repository
- **URL Format**: https://github.com/YOUR_USERNAME/docker-assessment2

### 2. Assets Built
Document the following built assets:
- `DockerAssessment.MvcApp.dll` (Main application)
- `appsettings.json` (Configuration)
- `appsettings.Production.json` (Production config)
- Entity Framework Core libraries
- ASP.NET Core MVC libraries
- Bootstrap and jQuery libraries
- All compiled views and static files

### 3. Dockerfile
Submit your complete Dockerfile showing:
- Multi-stage build configuration
- Base images used
- Application build process
- Security configurations (non-root user)
- Health check implementation

### 4. Azure Deployment URLs
- **Front-end URL**: https://mvc-app-leomark-jalop.azurewebsites.net
- **API Health Check**: https://mvc-app-leomark-jalop.azurewebsites.net/api/api/health
- **Container Registry**: acrleomarkjalop.azurecr.io
- **Resource Group**: rg-docker-assessment-leomark

---

## Troubleshooting

### Azure CLI Issues
```bash
# Check Azure CLI version
az --version

# Login with device code if regular login fails
az login --use-device-code

# Check current account
az account show
```

### Docker Issues
```bash
# Check Docker is running
docker --version

# View running containers
docker ps

# View container logs
docker logs <container-id>

# Remove containers and images for fresh start
docker system prune -a
```

### Application Issues
```bash
# Check application logs
dotnet run --verbosity diagnostic

# Test API endpoints
curl http://localhost:8080/api/api/health
```

---

## Student Information

- **Name**: Leomark Jalop
- **Email**: leomark.jalop@studytafensw.edu.au
- **Azure Subscription**: Azure for Students
- **Assessment**: Docker Containerization and Azure Deployment

---

## Important Notes

1. **Azure Student Credits**: Monitor your Azure student credits usage
2. **Resource Cleanup**: After assessment, clean up Azure resources to save credits
3. **Security**: Never commit secrets or passwords to GitHub
4. **Documentation**: Keep detailed notes of any issues encountered and solutions
5. **Backup**: Ensure all work is pushed to GitHub before submission

---

## Final Checklist

- [ ] Azure CLI installed and configured
- [ ] Logged in with student account (leomark.jalop@studytafensw.edu.au)
- [ ] Application builds successfully
- [ ] Docker image builds and runs locally
- [ ] Container deployed to Azure
- [ ] All URLs accessible and working
- [ ] GitHub repository created and code pushed
- [ ] All deliverables documented
