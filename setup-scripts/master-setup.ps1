# Master script to set up the entire Azure Dev Box environment
# This script orchestrates the entire setup process

# Load the central configuration
. $PSScriptRoot\config-definitions.ps1

# Check if running in UI mode
$uiMode = $false
if ($env:SELECTED_COMPONENTS) {
    $uiMode = $true
    $selectedComponents = $env:SELECTED_COMPONENTS -split ","
    
    # Parse user options if available
    if ($env:USER_OPTIONS) {
        try {
            $userOptions = $env:USER_OPTIONS | ConvertFrom-Json -AsHashtable
        }
        catch {
            Write-Host "Warning: Unable to parse USER_OPTIONS: $($_.Exception.Message)" -ForegroundColor Yellow
            $userOptions = @{}
        }
    }
    else {
        $userOptions = @{}
    }
    
    Write-Host "Running in UI mode with selected components: $($selectedComponents -join ', ')" -ForegroundColor Cyan
}

Write-Host "Starting development environment setup..." -ForegroundColor Cyan

# Step 0: Update task definitions to ensure catalog.json and devbox-task.json are in sync
Write-Host "Step 0: Updating task definitions..." -ForegroundColor Yellow
. $PSScriptRoot\update-task-definitions.ps1

# Step 1: Set up project directory structure, files and templates
Write-Host "Step 1: Setting up project directory structure and templates..." -ForegroundColor Yellow
if ($uiMode -and $userOptions.ContainsKey("ProjectStructure")) {
    . $PSScriptRoot\setup-files-folders.ps1 -ProjectStructure $userOptions.ProjectStructure
}
else {
    . $PSScriptRoot\setup-files-folders.ps1
}

# Step 2: Install developer tools
Write-Host "Step 2: Installing developer tools..." -ForegroundColor Yellow
if ($uiMode) {
    . $PSScriptRoot\install-tools.ps1 -Components $selectedComponents
}
else {
    . $PSScriptRoot\install-tools.ps1
}

# Step 3: Configure Git
Write-Host "Step 3: Configuring Git..." -ForegroundColor Yellow
if ($uiMode -and $env:GIT_USERNAME -and $env:GIT_EMAIL) {
    . $PSScriptRoot\git-configuration.ps1 -GitUsername $env:GIT_USERNAME -GitEmail $env:GIT_EMAIL
}
else {
    . $PSScriptRoot\git-configuration.ps1
}

# Step 4: Configure VS Code
Write-Host "Step 4: Configuring VS Code..." -ForegroundColor Yellow
if ($uiMode -and $userOptions.ContainsKey("VSCodeConfig")) {
    . $PSScriptRoot\vscode-configuration.ps1 -ConfigType $userOptions.VSCodeConfig
}
else {
    . $PSScriptRoot\vscode-configuration.ps1
}

# Step 5: Set up environment variables
Write-Host "Step 5: Setting up environment variables..." -ForegroundColor Yellow
. $PSScriptRoot\setup-environment.ps1

# Step 6: Install Azure CLI extensions for Dev Box
Write-Host "Step 6: Setting up Azure CLI extensions..." -ForegroundColor Yellow
if (-not $uiMode -or ($uiMode -and $selectedComponents -contains "azure-cli")) {
    az extension add --name devcenter --only-show-errors
}

Write-Host "Development environment setup complete!" -ForegroundColor Green
Write-Host "Your Azure Dev Box is ready for use." -ForegroundColor Cyan

# Show summary of what was set up
Write-Host "`nSummary of Setup:" -ForegroundColor Yellow
Write-Host "- Project structure created at C:\Projects"
Write-Host "- Developer tools installed"
Write-Host "- Git configured with aliases and global gitignore"
Write-Host "- VS Code configured with settings and extensions"
Write-Host "- Environment variables set"
Write-Host "- Azure CLI extensions installed"

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Clone your repositories into the appropriate folders"
Write-Host "2. Sign in to your Azure account using: az login"
Write-Host "3. Review the VS Code settings and customize as needed"