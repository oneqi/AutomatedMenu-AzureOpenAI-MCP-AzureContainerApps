#  Azure OpenAI Model Availability Check Script
#  This script checks the availability of a specified Azure OpenAI model in a given region.
do {
  $location = Read-Host -Prompt "Enter Azure region (e.g., westeurope, eastus)"
  $azureOpenAIModel = Read-Host -Prompt "Enter the Azure OpenAI Model to deploy (e.g., gpt-4o, gpt-35-turbo)"
  Write-Host "`nChecking Azure OpenAI Model '$azureOpenAIModel' Availability in region '$location'..." -ForegroundColor Cyan

# List available models for OpenAI in region
  $availableModels = Get-AzCognitiveServicesModel -Location $location |
      Where-Object { $_.Kind -eq "openai" } |
      Select-Object -ExpandProperty ModelProperty |
      Where-Object { $_.Name -like "${azureOpenAIModel}*" } |
      Sort-Object -Property name -Unique |
      Select-Object name, version, skus
      #Select-Object name

# Output the result
  Write-Host "Available OpenAI models in ${location}:"
  $availableModels | Format-Table -AutoSize

  if ($availableModels.name -contains $azureOpenAIModel) {
      Write-Host "Model '$azureOpenAIModel' is AVAILABLE in region '$location'." -ForegroundColor Green
  } else {
      Write-Host "Model '$azureOpenAIModel' is NOT available in region '$location'." -ForegroundColor Red
  }
  Write-Host "This script only deploys models with 'Standard' SKU. If it is NOT listed please choose a different region." -ForegroundColor Red
  Write-Host "Press 'N' and choose a different region ..." -ForegroundColor Red

  write-Host "`nIf you are not happy with the details press N and the script will re-run ..." -ForegroundColor Cyan
  $confirmation = Read-Host "Are you happy with these details? (Y/N)"
}
until ($confirmation -match "^[Yy]$")