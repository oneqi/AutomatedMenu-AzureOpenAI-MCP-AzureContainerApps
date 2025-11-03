# Creating Azure Container Registry
#$WarningPreference = 'SilentlyContinue'
# $WarningPreference = 'Continue'

Write-Host "`nCreating Azure Container Registry (ACR) ..." -ForegroundColor Cyan
$acrResource = New-AzContainerRegistry -ResourceGroupName $resourceGroup `
                                       -Name $acrName `
                                       -Sku Basic `
                                       -Location $location > $null
if ($LASTEXITCODE -eq 0) {
Write-Host "Azure Container Registry $($acrResource.Name) created successfully in resource group $($acrResource.ResourceGroupName)." -ForegroundColor Green
}

Write-Host "Enabling Admin Login on the ACR ..." -ForegroundColor Cyan
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
Write-Host "ACR Username is $acrUsername" -ForegroundColor Cyan
Write-Host "ACR Password is $acrPassword" -ForegroundColor Cyan
Write-Host "ACR Login Server name is $acrLoginServer" -ForegroundColor Cyan
# Sending to parent script via global variables
$global:acrLoginServer = $acrLoginServer
$global:acrUsername = $acrUsername
$global:acrPassword = $acrPassword
Write-Host "Exported configuration variables:" -ForegroundColor Cyan
Write-Host "Azure Container Registry setup completed." -ForegroundColor Green
#$WarningPreference = 'Continue'