# ASP.NET MVC Docker Assessment - Complete Instructions

## Objective
This assessment evaluates your ability to containerize an ASP.NET MVC application using Docker and deploy it to Azure. You'll demonstrate understanding of Docker, version control with GitHub, and Azure deployment services.

## Prerequisites
- Visual Studio 2022 or later
- Docker Desktop
- Git
- GitHub account
- Azure account (with subscription)

## Step-by-Step Instructions

### 1. Log onto Lab Computer
- Ensure Visual Studio 2022 is installed
- Verify .NET 8.0 SDK is available
- Check that Git is installed and configured

### 2. Install and Configure Docker
```bash
# Download Docker Desktop from https://www.docker.com/products/docker-desktop/
# Install Docker Desktop
# Start Docker Desktop and ensure it's running
docker --version
docker-compose --version
```

### 3. Create GitHub Account
- Visit https://github.com and create an account (if not already created)
- Note your GitHub username for instructor submission
- Student Email: leomark.jalop@studytafensw.edu.au

### 4. Add Local Code to GitHub Repository
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit - ASP.NET MVC application"

# Create new repository on GitHub (replace with your username)
# Add remote origin
git remote add origin https://github.com/YOUR_USERNAME/docker-assessment2.git
git branch -M main
git push -u origin main
```

### 5. Open Repository in Visual Studio
- Clone the repository: `git clone https://github.com/YOUR_USERNAME/docker-assessment2.git`
- Open the solution file in Visual Studio

### 6. Build Solution and Identify Assets
- Build the solution in Visual Studio (Build → Build Solution)
- Identify assets in `bin/Release/net8.0/` folder:
  - Main DLL files
  - Configuration files (appsettings.json, web.config)
  - Static files (CSS, JS, images)
  - Dependencies and NuGet packages

### 7. Build Docker File with Assets
- Create Dockerfile in project root
- Include all necessary assets for containerization

### 8. Start Local Container
```bash
# Build Docker image
docker build -t mvc-app .

# Run container locally
docker run -p 8080:8080 mvc-app

# Test container
docker ps
```

### 9. Test Application
- Navigate to `http://localhost:8080`
- Verify all pages load correctly
- Test functionality (forms, navigation, etc.)

### 10. Deploy to Azure
```bash
# Login to Azure with your student account
az login --use-device-code

# When prompted, use these credentials:
# Email: leomark.jalop@studytafensw.edu.au
# Password: [Your Azure student account password]

# Create resource group
az group create --name rg-docker-assessment-leomark --location eastus

# Create Azure Container Registry (ACR names must be globally unique)
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

## Required Deliverables
1. **GitHub Repository URL**: https://github.com/YOUR_USERNAME/docker-assessment2
2. **Assets Built**: List of all compiled assets and dependencies
3. **Dockerfile**: Complete Dockerfile with all configurations
4. **Azure URL**: URL of deployed application on Azure

## Troubleshooting
- If Docker build fails, check Dockerfile syntax
- If container doesn't start, verify port configurations
- If Azure deployment fails, check ACR permissions and image tags
- Use `docker logs <container-id>` to debug container issues

## Assessment Criteria
- Successful containerization of ASP.NET MVC application
- Proper Docker configuration and optimization
- Successful deployment to Azure
- Documentation and code quality
- Working application with all functionality preserved
