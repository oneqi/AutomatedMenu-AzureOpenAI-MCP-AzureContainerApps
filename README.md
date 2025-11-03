# AutomatedMenu-AzureOpenAI-MCP-AzureContainerApps
## N.B. Important - This is for testing in a lab environment (not for Production)
### Requirements
- Command Prompt with Powershell
  - Az Cli (able to run within Powershell)

### How the 'Automated Menu' works
- The script outputs a menu which is numbered, so you can select which option you require or quit out of the script
  - 1. The script will detect which of the following environments it is running in;
    - Azure Cloud Shell
    - Windows Powershell Prompt
    - WSL with pwsh
    - Docker container
      - Once the environment is detected, it will then log you into Azure using your TenantID as an input
  - 2. You will then be able to check which Azure region has a 'Standard' SKU of the OpenAI Model you wish to work with
  - 3. Once the region is choosen, you can then choose a project name that will used in the resource names that are created (some will have to be globally unique)
    - Using the project name, the following resources can be selected to be created
      - Resource Group
      - Azure Container Registry (ACR)
      - Azure Container App (ACA)
        - A Dockerfile is used to build an image, pushed to ACR, and used by the ACA

### What the lab produces
- The lab will create a public facing 'frontend' web app where a prompt is used to ask for information related to Microsoft Docs.
- The web app will utilise a MCP server which searches Microsoft Docs for an answer.
- The result of the search is sent an OpenAI Model to assimulate an answer.

### Directions
- Choose a Powershell command prompt that can also call AzCli, e.g. Azure Cloud Shell
- Download the repo, e.g.
```bash
git clone https://github.com/oneqi/AutomatedMenu-AzureOpenAI-MCP-AzureContainerApps.git
```
- Change directory
```bash
cd ./AutomatedMenu-AzureOpenAI-MCP-AzureContainerApps
```
- Run the 'parent' powershell script
```yaml
.\Parent-Command.ps1
```
- You should see the following output
```yaml
Using child scripts to modularise the process and allow flexibility.

Available Child Scripts to Run:
1. Prompt detection, Azure Login and select Subscription
2. Check Azure OpenAI Model Availability
3. Set project variables
4. Create Resource Group
5. Create Azure OpenAI
6. Create Azure Container Registry
7. Create Azure ContainerApp for Chat with MCP for MS Learn
Q. Quit
Enter the number of the child script to run or 'Q' to quit:
```
