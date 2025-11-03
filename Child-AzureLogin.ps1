# Detect Execution Environment function
function Get-ExecutionEnvironment {
    # Default to Unknown
    $environment = "Unknown"

    # Check 1: Azure Cloud Shell
    # Cloud Shell sets these environment variables automatically
    if ($env:CLOUD_SHELL -or $env:ACC_CLOUD -or ($env:HOME -like "/home/cloud*")) {
        $environment = "AzureCloudShell"
    }
    # Check 2: Docker container environment
    #elseif (Test-Path '/.dockerenv') {
    elseif ((Test-Path '/.dockerenv') -or (Get-Content "/proc/1/cgroup" -ErrorAction SilentlyContinue | Select-String -Pattern "docker")) {
        $environment = "DockerContainer"
    }
    # Check 3: Windows OS (native PowerShell)
    elseif ($IsWindows) {
        $environment = "Windows"
    }
    # Check 4: Linux (e.g., WSL or native PowerShell Core)
    elseif ($IsLinux) {
        # Distinguish WSL2 if possible
        if ((Test-Path "/proc/version") -and (Get-Content "/proc/version" | Select-String -Pattern "microsoft")) {
            $environment = "Linux-WSL2"
        } else {
            $environment = "Linux"
        }
    }

    return $environment
}

$detectedEnv = Get-ExecutionEnvironment
$lowerDetectedEnv = $detectedEnv.ToLower()
Write-Host "`nDetected Environment: ${lowerDetectedEnv}`n" -ForegroundColor Green

# Azure Login, List and Select Subscription
if ( $lowerDetectedEnv -ne 'azurecloudshell') {
  # Obtaining tenant Id
  $tenantInput = Read-Host -Prompt "Enter the tenant ID you want to use"

  # Login to Azure interactively
  Write-Host "Logging into Azure..." -ForegroundColor Cyan
  #Connect-AzAccount --use-device-code | Out-Null
  Connect-AzAccount -UseDeviceAuthentication -Tenant $tenantInput
} else {
  Write-Host "Running in Azure Cloud Shell ..." -ForegroundColor Yellow
  Write-Host "`nRetrieving available subscriptions..." -ForegroundColor Cyan
  $subscriptions = Get-AzSubscription | Select-Object Name, Id
  $subscriptions | Format-Table

  $subscriptionInput = Read-Host -Prompt "Enter subscription Name or ID you want to use"

  # Attempt to set Azure context to the specified subscription
  try {
      Set-AzContext -Subscription $subscriptionInput -ErrorAction Stop #| Out-Null
      $context = Get-AzContext
      Write-Host "Context set to subscription: $($context.Subscription.Name) [$($context.Subscription.Id)]" -ForegroundColor Green
  } catch {
      Write-Host "Invalid subscription name or ID. Please ensure it exists and try again." -ForegroundColor Red
      exit
  }
}

Write-Host "Azure login and subscription selection completed." -ForegroundColor Green

$global:selectedSubscriptionId = (Get-AzContext).Subscription.Id
$global:selectedTenantId = (Get-AzContext).Tenant.Id
$global:selectedSubscriptionName = (Get-AzContext).Subscription.Name
Write-Host "`nExportedcontext variables" -ForegroundColor Cyan
Write-Host "`nSelected Tenant ID: $global:selectedTenantId" -ForegroundColor Green
Write-Host "Selected Subscription Name: $global:selectedSubscriptionName" -ForegroundColor Green
Write-Host "Selected Subscription ID: $global:selectedSubscriptionId" -ForegroundColor Green

