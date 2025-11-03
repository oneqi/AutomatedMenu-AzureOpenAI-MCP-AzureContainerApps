Write-Host "Using child scripts to modularise the process and allow flexibility." -ForegroundColor Cyan

# creating a numbered list of child scripts to run in order
# using a loop to select and run the numbered child script
# using 'Q/q' to quit the loop
# after each script runs, the loop will prompt for the next script to run
# this allows for flexibility in running the scripts in any order or skipping scripts as needed
do {
    Write-Host "`nAvailable Child Scripts to Run:" -ForegroundColor Yellow
    Write-Host "1. Prompt detection, Azure Login and select Subscription" -ForegroundColor Yellow
    Write-Host "2. Check Azure OpenAI Model Availability" -ForegroundColor Yellow
    Write-Host "3. Set project variables" -ForegroundColor Yellow
    Write-Host "4. Create Resource Group" -ForegroundColor Yellow
    Write-Host "5. Create Azure OpenAI plus Model" -ForegroundColor Yellow
    Write-Host "6. Create Azure Container Registry" -ForegroundColor Yellow
    Write-Host "7. Create Azure ContainerApp for Chat with MCP for MS Learn" -ForegroundColor Yellow
    Write-Host "Q. Quit" -ForegroundColor Yellow
    $scriptNumber = Read-Host -Prompt "Enter the number of the child script to run or 'Q' to quit"
    switch ($scriptNumber) {
        '1' {
            Write-Host "Starting Prompt detection, Azure login and subscription selection..." -ForegroundColor Cyan
            . "$PSScriptRoot\Child-AzureLogin.ps1"
        }
        '2' {
            Write-Host "Checking Azure Model availability via OpenAI..." -ForegroundColor Cyan
            . "$PSScriptRoot\Child-AvailabilityAzureOpenAi.ps1"
        }
        '3' {
            Write-Host "Starting project configuration and variable setup..." -ForegroundColor Cyan
            . "$PSScriptRoot\Child-SetVariables.ps1"
        }
        '4' {
            Write-Host "Starting Resource Group creation..." -ForegroundColor Cyan
            . "$PSScriptRoot\Child-CreateResourceGroup.ps1"
        }
        '5' {
            Write-Host "Starting AI resource creation..." -ForegroundColor Cyan
            . "$PSScriptRoot\Child-CreateAzureOpenAI.ps1"
        }
        '6' {
            Write-Host "Starting Azure Container Registry creation..." -ForegroundColor Cyan
            . "$PSScriptRoot\Child-CreateAzureContainerRegistry.ps1"
        }
        '7' {
            Write-Host "Starting Azure MCP Chat with MS Learn creation..." -ForegroundColor Cyan
            . "$PSScriptRoot\Child-WebMCPAzureDocs.ps1"
        }
        'Q' { Write-Host "Exiting the script." -ForegroundColor Yellow }
        'q' { Write-Host "Exiting the script." -ForegroundColor Yellow }
        Default { Write-Host "Invalid selection. Please enter a valid number or 'Q' to quit." -ForegroundColor Red }
    }

} until ($scriptNumber -eq 'Q' -or $scriptNumber -eq 'q')

