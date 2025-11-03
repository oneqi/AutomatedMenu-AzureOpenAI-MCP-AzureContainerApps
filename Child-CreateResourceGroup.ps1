# Create Resource Group
Write-Host "Creating Resource Group '$global:resourceGroup' in location '$global:location'..." -ForegroundColor Cyan
try {
    $rg = New-AzResourceGroup -Name $global:resourceGroup -Location $global:location -ErrorAction Stop
    Write-Host "`nResource Group '$($rg.ResourceGroupName)' created successfully in location '$($rg.Location)'." -ForegroundColor Green
} catch {
    Write-Host "`nFailed to create Resource Group '$global:resourceGroup'. Error: $_" -ForegroundColor Red
    exit 1
}

# Exporting Resource Group as global variable
$global:resourceGroup = $rg.ResourceGroupName
Write-Host "Exported Resource Group name as global variable" -ForegroundColor Cyan
Write-Host "Resource Group creation process completed." -ForegroundColor Green
