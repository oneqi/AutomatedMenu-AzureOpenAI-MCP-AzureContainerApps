# Moving to the correct directory
#Set-Location .\web-mcp-azure-docs

# Using global variables from parent script
$AOAI_ENDPOINT = $Global:aoaiEndpoint
$AOAI_KEY = $Global:aoaiKey
$DEPLOYMENT_NAME = $Global:azureOpenAIModel

# Building image and pushing to ACR
Write-Host "`nBuilding and pushing Docker images..." -ForegroundColor Cyan
az acr build --registry $acrName --image "${frontendApp}:v1" --file web-mcp-azure-docs/Dockerfile web-mcp-azure-docs
if ($LASTEXITCODE -eq 0) {
Write-Host "Docker image '${frontendApp}:v1' built and pushed to ACR successfully." -ForegroundColor Green
}

Write-Host "N.B. You may need to update 'az containerapp !" -ForegroundColor Magenta
Write-Host "az extension add --name containerapp --upgrade" -ForegroundColor Magenta
# Creating Container App Environment
Write-Host "`nCreating Container App Environment..." -ForegroundColor Cyan
az containerapp env create `
  --name $acaEnvName `
  --resource-group $resourceGroup `
  --location $location > null
if ($LASTEXITCODE -eq 0) {
Write-Host "Container App Environment '$acaEnvName' created successfully." -Foreground Green
}

# Login into ACR
#Write-Host "`nLogging into ACR ..."
#az acr login --name $acrName

# Creating Container App
Write-Host "`nCreating Container App..." -ForegroundColor Cyan
az containerapp create `
  --name $frontendApp `
  --resource-group $resourceGroup `
  --environment $acaEnvName `
  --registry-server $acrLoginServer `
  --registry-username $acrUsername `
  --registry-password $acrPassword `
  --image "$acrLoginServer/${frontendApp}:v1" `
  --cpu 1 `
  --memory 2.0Gi `
  --ingress 'external' `
  --target-port 3000 `
  --env-vars AZURE_OPENAI_ENDPOINT=$AOAI_ENDPOINT `
             AZURE_OPENAI_KEY=$AOAI_KEY `
             AZURE_OPENAI_DEPLOYMENT_NAME=$DEPLOYMENT_NAME > null
if ($LASTEXITCODE -eq 0) {
Write-Host "Container App '$frontendApp' created successfully." -ForegroundColor Green
}

# Retrieving Container App URL
Write-Host "`nRetrieving Container App URL..." -ForegroundColor Cyan
$containerAppUrl = az containerapp show `
                        --name $frontendApp `
                        --resource-group $resourceGroup `
                        --query "properties.configuration.ingress.fqdn" `
                        --output tsv
if ($LASTEXITCODE -eq 0) {
Write-Host "Container App URL retrieved successfully." -ForegroundColor Green
}

# Output the Container App URL
Write-Host "`nContainer App URL: https://${containerAppUrl}" -ForegroundColor Yellow

# Sending to parent script via global variables
$Global:containerAppUrl = $containerAppUrl
Write-Host "Exported configuration variables:" -ForegroundColor Cyan
Write-Host "Container App setup completed." -ForegroundColor Green

Write-Host "Open the URL and ask questions related to Azure Docs content!" -ForegroundColor Magenta
Write-Host "https://${containerAppUrl}" -ForegroundColor Magenta
Write-Host "e.g. What is Azure Container Apps?" -ForegroundColor Magenta