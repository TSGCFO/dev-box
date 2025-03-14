# Master script to set up the entire Azure Dev Box environment
# This script orchestrates the entire setup process

Write-Host "Starting development environment setup..." -ForegroundColor Cyan

# Step 1: Set up project directory structure
Write-Host "Step 1: Setting up project directory structure..." -ForegroundColor Yellow
$projectFolders = @(
    "C:\Projects",
    "C:\Projects\WebApps",
    "C:\Projects\Scripts",
    "C:\Projects\Libraries",
    "C:\Projects\Experiments",
    "C:\Projects\Documentation",
    "C:\Projects\Config",
    "C:\Projects\Templates"
)

foreach ($folder in $projectFolders) {
    if (!(Test-Path -Path $folder)) {
        New-Item -Path $folder -ItemType Directory -Force
        Write-Host "Created folder: $folder" -ForegroundColor Green
    }
}

# Step 2: Install developer tools
Write-Host "Step 2: Installing developer tools..." -ForegroundColor Yellow
. $PSScriptRoot\install-tools.ps1

# Step 3: Configure Git
Write-Host "Step 3: Configuring Git..." -ForegroundColor Yellow
. $PSScriptRoot\git-configuration.ps1

# Step 4: Configure VS Code
Write-Host "Step 4: Configuring VS Code..." -ForegroundColor Yellow
. $PSScriptRoot\vscode-configuration.ps1

# Step 5: Set up environment variables
Write-Host "Step 5: Setting up environment variables..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("NODE_ENV", "development", "User")
[Environment]::SetEnvironmentVariable("PYTHONPATH", "C:\Projects", "User")
[Environment]::SetEnvironmentVariable("EDITOR", "code", "User")
[Environment]::SetEnvironmentVariable("PROJECTS_ROOT", "C:\Projects", "User")

# Step 6: Install Azure CLI extensions for Dev Box
Write-Host "Step 6: Setting up Azure CLI extensions..." -ForegroundColor Yellow
az extension add --name devcenter --only-show-errors

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