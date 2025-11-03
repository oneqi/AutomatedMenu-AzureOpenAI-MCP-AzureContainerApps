Write-Host "Creating Azure Container Registry (ACR) ..." -ForegroundColor Cyan
New-AzContainerRegistry -ResourceGroupName $resourceGroup `
                        -Name $acrName `
                        -Sku Basic `
                        -Location $location > $null
if ($LASTEXITCODE -eq 0) {
Write-Host "Azure Container Registry $acrName created successfully in resource group ${resourceGroup}." -ForegroundColor Green
}

Write-Host "`nEnabling Admin Login on the ACR ..." -ForegroundColor Cyan
$updateResource = Update-AzContainerRegistry -Name $acrName `
                                             -ResourceGroupName $ResourceGroup `
                                             -EnableAdminUser
Write-Host "Admin Login is '$($updateResource.AdminUserEnabled)' (enabled) on ACR '$($updateResource.Name)'." -ForegroundColor Green

# Get ACR credentials (this uses admin credentials for simplicity)
$acrCred = Get-AzContainerRegistryCredential -ResourceGroupName $ResourceGroup -Name $ACRName
$acrLoginServer = $updateResource.LoginServer
$acrUsername = $acrCred.Username
$acrPassword = $acrCred.Password
# Showing values as this is a lab environment
Write-Host "`nACR Username is $acrUsername" -ForegroundColor Cyan
Write-Host "ACR Password is $acrPassword" -ForegroundColor Cyan
Write-Host "ACR Login Server name is $acrLoginServer" -ForegroundColor Cyan
# Sending to parent script via global variables
$global:acrLoginServer = $acrLoginServer
$global:acrUsername = $acrUsername
$global:acrPassword = $acrPassword
Write-Host "`nExported configuration variables:" -ForegroundColor Cyan
Write-Host "Azure Container Registry setup completed." -ForegroundColor Green
#$WarningPreference = 'Continue'