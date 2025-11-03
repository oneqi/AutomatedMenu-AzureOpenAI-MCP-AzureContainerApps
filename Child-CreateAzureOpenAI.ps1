# Create Azure OpenAI Instance
Write-Host "`nCreating Azure OpenAI Instance..." -ForegroundColor Cyan
az cognitiveservices account create `
  --name $aoaiName `
  --resource-group $resourceGroup `
  --location $location `
  --kind "OpenAI" `
  --sku "S0" > null
if ($LASTEXITCODE -eq 0) {
Write-Host "Azure OpenAI Instance '$aoaiName' created successfully." -ForegroundColor Green
}


# Create Azure OpenAI Deployment
Write-Host "`nCreating Azure OpenAI Deployment for model '$azureOpenAIModel' version '$azureOpenAIModelVersion'..." -ForegroundColor Cyan
az cognitiveservices account deployment create `
  --name "$aoaiName" `
  --resource-group $resourceGroup `
  --model-name $azureOpenAIModel `
  --deployment-name $azureOpenAIModel `
  --model-version $azureOpenAIModelVersion `
  --model-format "OpenAI" `
  --sku-name "Standard" `
  --sku-capacity 10 > null
if ($LASTEXITCODE -eq 0) {
Write-Host "Azure OpenAI Deployment for model '$azureOpenAIModel' version '$azureOpenAIModelVersion' created successfully." -ForegroundColor Green
}

# Retrieve Azure OpenAI Endpoint and Key
Write-Host "`nRetrieving Azure OpenAI Endpoint and Key..." -ForegroundColor Cyan
$aoaiEndpoint = az cognitiveservices account show `
                    --name $aoaiName `
                    --resource-group $resourceGroup `
                    --query "properties.endpoint" `
                    --output tsv
$aoaiKey = az cognitiveservices account keys list `
                --name $aoaiName `
                --resource-group $resourceGroup `
                --query "key1" `
                --output tsv
if ($LASTEXITCODE -eq 0) {
Write-Host "Azure OpenAI Endpoint and Key retrieved successfully." -ForegroundColor Green
}

# Output the Endpoint and Key as this is a lab environment
Write-Host "`nAzure OpenAI Endpoint: $aoaiEndpoint" -ForegroundColor Yellow
Write-Host "Azure OpenAI Key: $aoaiKey" -ForegroundColor Yellow

# Sending to parent script via global variables
$Global:aoaiEndpoint = $aoaiEndpoint
$Global:aoaiKey = $aoaiKey
Write-Host "`nExported configuration variables:" -ForegroundColor Cyan
Write-Host "Azure OpenAI setup completed." -ForegroundColor Green
