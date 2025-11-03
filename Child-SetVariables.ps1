do {

    # Ask for Azure OpenAI Model
    $azureOpenAIModel = Read-Host -Prompt "Enter the Azure OpenAI Model to deploy (e.g., gpt-4o, gpt-35-turbo)"
    # Ask for AI OpenAI Model Version
    $azureOpenAIModelVersion = Read-Host -Prompt "Enter the Azure OpenAI Model Version to deploy (e.g., 2024-05-13, 2024-02-15)"
    # Ask for project name and region
    $projectName = Read-Host -Prompt "Enter a unique project name with NO spaces, underscores, etc, e.g. projectx901"
    #$projectName = $projectName.ToLower().Replace(" ", "-")
    $projectName = $projectName.ToLower()
    $location = Read-Host -Prompt "Enter Azure region (e.g., westeurope, eastus)"

    # Derived resource names
    $azureOpenAIModel = $azureOpenAIModel.ToLower()
    $resourceGroup = "rg-$projectName"
    $acrName = "acr$($projectName.Substring(0, [Math]::Min(15, $projectName.Length)))"
    $acaEnvName = "aca-${projectName}"
    $aoaiName = "aoai-${projectName}"
    $frontendApp = "frontend-${projectName}"

    # Display summary back to the user
    Write-Host "`nReview your project configuration:" -ForegroundColor Cyan
    Write-Host "AI Model to Deploy:                      $azureOpenAIModel"
    Write-Host "AI Model Version:                        $azureOpenAIModelVersion"
    Write-Host "Project Name:                            $projectName"
    Write-Host "Azure Region:                            $location"
    Write-Host "Resource Group:                          $resourceGroup"
    Write-Host "Azure Container Registry Name:           $acrName"
    Write-Host "Azure ContainerApp Environment Name:     $acaEnvName"
    Write-Host "Azure OpenAI Instance Name:              $aoaiName"
    Write-Host "Frontend App:                            $frontendApp"
    Write-Host ""

    # check the names and ask for confirmation
    write-Host "`nIf you are not happy with the details press N and the script will re-run ..." -ForegroundColor Cyan
    $confirmation = Read-Host "Are you happy with these details? (Y/N)"
}
until ($confirmation -match "^[Yy]$")

Write-Host "`nConfiguration confirmed for project '$projectName'." -ForegroundColor Green
# Exporting variables as global
$global:azureOpenAIModel = $azureOpenAIModel
$global:azureOpenAIModelVersion = $azureOpenAIModelVersion
$global:projectName = $projectName
$global:location = $location
$global:resourceGroup = $resourceGroup
$global:acrName = $acrName
$global:acaEnvName = $acaEnvName
$global:aoaiName = $aoaiName
$global:frontendApp = $frontendApp
Write-Host "Exported configuration variables:" -ForegroundColor Cyan
Write-Host "`nListing the variable name and value for easy reference..."
Write-Host "Variable "(Get-Variable -Name azureOpenAIModel).Name"        = '$($global:azureOpenAIModel)'" -ForegroundColor Yellow
Write-Host "Variable "(Get-Variable -Name azureOpenAIModelVersion).Name" = '$($global:azureOpenAIModelVersion)'" -ForegroundColor Yellow
Write-Host "Variable "(Get-Variable -Name projectName).Name"             = '$($global:projectName)'" -ForegroundColor Yellow
Write-Host "Variable "(Get-Variable -Name location).Name"                = '$($global:location)'" -ForegroundColor Yellow
Write-Host "Variable "(Get-Variable -Name resourceGroup).Name"           = '$($global:resourceGroup)'" -ForegroundColor Yellow
Write-Host "Variable "(Get-Variable -Name acrName).Name"                 = '$($global:acrName)'" -ForegroundColor Yellow
Write-Host "Variable "(Get-Variable -Name acaEnvName).Name"              = '$($global:acaEnvName)'" -ForegroundColor Yellow
Write-Host "Variable "(Get-Variable -Name aoaiName).Name"                = '$($global:aoaiName)'" -ForegroundColor Yellow
Write-Host "Variable "(Get-Variable -Name frontendApp).Name"             = '$($global:frontendApp)'" -ForegroundColor Yellow
Write-Host "Project variable setup completed." -ForegroundColor Green