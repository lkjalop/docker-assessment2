# Use the official ASP.NET Core runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["DockerAssessment.MvcApp.csproj", "./"]
RUN dotnet restore "DockerAssessment.MvcApp.csproj"

# Copy the entire project and build
COPY . .
RUN dotnet build "DockerAssessment.MvcApp.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "DockerAssessment.MvcApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage: Copy the published app to the runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Set environment variables
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:8080

# Create a non-root user for security
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/api/api/health || exit 1

# Run the application
ENTRYPOINT ["dotnet", "DockerAssessment.MvcApp.dll"]
