# Docker Assessment - ASP.NET Core MVC Application
## Student: Leomark Jalop (leomark.jalop@studytafensw.edu.au)

This repository contains a complete ASP.NET Core MVC application designed for Docker containerization and Azure deployment assessment.

## Project Overview

This application demonstrates:
- ASP.NET Core 8.0 MVC pattern implementation
- Entity Framework Core with In-Memory database
- RESTful API endpoints
- Docker containerization
- Azure cloud deployment
- CI/CD pipeline setup

## Features

- **Product Management**: Full CRUD operations for products
- **Category Management**: Product categorization system
- **RESTful API**: JSON endpoints for external integration
- **Health Checks**: Application health monitoring
- **Swagger Documentation**: Interactive API documentation
- **Bootstrap UI**: Responsive, modern user interface

## Prerequisites

- .NET 8.0 SDK
- Docker Desktop
- Azure CLI (for deployment)
- Git
- Visual Studio 2022 or VS Code

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/docker-assessment2.git
cd docker-assessment2
```

### 2. Run Locally (Without Docker)

```bash
dotnet restore
dotnet build
dotnet run
```

Visit `https://localhost:5001` or `http://localhost:5000`

### 3. Run with Docker

```bash
# Build the Docker image
docker build -t mvc-app .

# Run the container
docker run -p 8080:8080 mvc-app
```

Visit `http://localhost:8080`

### 4. Using Docker Compose

```bash
docker-compose up --build
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/api/health` | GET | Health check |
| `/api/api/products` | GET | Get all products |
| `/api/api/products/{id}` | GET | Get product by ID |
| `/api/api/categories` | GET | Get all categories |
| `/swagger` | GET | API documentation |

## Docker Configuration

### Dockerfile Explanation

```dockerfile
# Multi-stage build for optimized production image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# ... (see Dockerfile for complete configuration)
```

### Key Docker Features

- **Multi-stage build**: Reduces final image size
- **Non-root user**: Enhanced security
- **Health checks**: Container health monitoring
- **Environment variables**: Configurable settings
- **Port configuration**: Standardized port 8080

## Azure Deployment

### Option 1: Using Azure CLI Script (Linux/macOS)

```bash
chmod +x deploy-azure.sh
./deploy-azure.sh
```

### Option 2: Using PowerShell Script (Windows)

```powershell
.\deploy-azure.ps1 -ResourceGroupName "rg-docker-assessment" -Location "East US" -AppServicePlanName "asp-docker-assessment" -WebAppName "mvc-app-web" -ACRName "acrdockerassessment" -ImageName "mvc-app"
```

### Option 3: Manual Azure Deployment

1. **Login to Azure**
   ```bash
   az login
   ```

2. **Create Resource Group**
   ```bash
   az group create --name rg-docker-assessment --location eastus
   ```

3. **Create Azure Container Registry**
   ```bash
   az acr create --resource-group rg-docker-assessment --name myacrregistry --sku Basic
   ```

4. **Build and Push Image**
   ```bash
   az acr login --name myacrregistry
   docker build -t mvc-app .
   docker tag mvc-app myacrregistry.azurecr.io/mvc-app:latest
   docker push myacrregistry.azurecr.io/mvc-app:latest
   ```

5. **Create App Service Plan**
   ```bash
   az appservice plan create --name asp-docker-assessment --resource-group rg-docker-assessment --sku B1 --is-linux
   ```

6. **Create Web App**
   ```bash
   az webapp create --resource-group rg-docker-assessment --plan asp-docker-assessment --name mvc-app-web --deployment-container-image-name myacrregistry.azurecr.io/mvc-app:latest
   ```

## Project Structure

```
docker-assessment2/
├── Controllers/           # MVC Controllers
│   ├── HomeController.cs
│   ├── ProductsController.cs
│   └── ApiController.cs
├── Data/                  # Entity Framework Context
│   └── ApplicationDbContext.cs
├── Models/                # Data Models
│   ├── Product.cs
│   ├── Category.cs
│   └── ErrorViewModel.cs
├── Views/                 # Razor Views
│   ├── Home/
│   ├── Products/
│   └── Shared/
├── wwwroot/               # Static Files
│   ├── css/
│   └── js/
├── .github/workflows/     # GitHub Actions
├── Dockerfile             # Docker configuration
├── docker-compose.yml     # Docker Compose configuration
├── deploy-azure.sh        # Azure deployment script (Linux)
├── deploy-azure.ps1       # Azure deployment script (Windows)
└── README.md             # This file
```

## Built Assets

When building the application, the following assets are generated:

- **Primary Assembly**: `DockerAssessment.MvcApp.dll`
- **Configuration Files**: `appsettings.json`, `appsettings.Production.json`
- **Dependencies**: Entity Framework Core, ASP.NET Core MVC, Swagger
- **Static Files**: CSS, JavaScript, Bootstrap libraries
- **Views**: Compiled Razor views

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ASPNETCORE_ENVIRONMENT` | Application environment | Development |
| `ASPNETCORE_URLS` | Listening URLs | http://+:8080 |
| `ConnectionStrings__DefaultConnection` | Database connection | In-Memory DB |

## Testing

### Local Testing

```bash
# Test the application locally
dotnet test

# Test Docker container
docker run -p 8080:8080 mvc-app
curl http://localhost:8080/api/api/health
```

### Production Testing

```bash
# Test deployed application
curl https://your-app-name.azurewebsites.net/api/api/health
```

## CI/CD Pipeline

The repository includes a GitHub Actions workflow (`.github/workflows/azure-deploy.yml`) that:

1. Builds the .NET application
2. Runs tests
3. Builds Docker image
4. Pushes to Azure Container Registry
5. Deploys to Azure Web App

### Required GitHub Secrets

- `REGISTRY_LOGIN_SERVER`: ACR login server
- `REGISTRY_USERNAME`: ACR username
- `REGISTRY_PASSWORD`: ACR password
- `AZURE_WEBAPP_PUBLISH_PROFILE`: Azure Web App publish profile

## Troubleshooting

### Common Issues

1. **Docker Build Fails**
   - Ensure Docker Desktop is running
   - Check Dockerfile syntax
   - Verify .dockerignore file

2. **Container Won't Start**
   - Check port configuration
   - Verify environment variables
   - Review container logs: `docker logs <container-id>`

3. **Azure Deployment Fails**
   - Verify Azure CLI authentication
   - Check resource group permissions
   - Ensure ACR access permissions

### Health Check

The application includes a health check endpoint at `/api/api/health` that returns:

```json
{
  "status": "healthy",
  "timestamp": "2025-01-01T00:00:00Z",
  "environment": "Production"
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is created for educational purposes as part of a Docker containerization assessment.

## Assessment Deliverables

For the assessment, ensure you have:

1. **GitHub Repository URL**: https://github.com/YOUR_USERNAME/docker-assessment2
2. **Assets Built**: All compiled DLLs, configuration files, and dependencies
3. **Dockerfile**: Complete Docker configuration with multi-stage build
4. **Azure URL**: https://mvc-app-leomark-jalop.azurewebsites.net

## Student Information

- **Name**: Leomark Jalop
- **Email**: leomark.jalop@studytafensw.edu.au
- **Azure Container Registry**: acrleomarkjalop.azurecr.io
- **Resource Group**: rg-docker-assessment-leomark

## Support

For questions or issues with this assessment project, please refer to the `INSTRUCTIONS.md` file or contact your instructor.