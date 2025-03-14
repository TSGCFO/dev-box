# Script to synchronize catalog.json and devbox-task.json
# This ensures both files have consistent task definitions

Write-Host "Updating task definitions in catalog.json and devbox-task.json..." -ForegroundColor Cyan

# Define the common task definitions
$taskDefinitions = @(
    @{
        name = "setup-dev-environment"
        description = "Sets up the complete development environment"
        script = "setup-scripts/master-setup.ps1"
        runElevated = $true
        runOnce = $false
    },
    @{
        name = "setup-files-folders"
        description = "Creates standard file structure, templates, and example files"
        script = "setup-scripts/setup-files-folders.ps1"
        runElevated = $false
        runOnce = $false
    },
    @{
        name = "update-tools"
        description = "Updates all developer tools"
        script = "setup-scripts/install-tools.ps1"
        runElevated = $true
        runOnce = $false
    },
    @{
        name = "configure-git"
        description = "Reconfigures Git settings"
        script = "setup-scripts/git-configuration.ps1"
        runElevated = $false
        runOnce = $false
    },
    @{
        name = "configure-vscode"
        description = "Updates VS Code settings and extensions"
        script = "setup-scripts/vscode-configuration.ps1"
        runElevated = $false
        runOnce = $false
    },
    @{
        name = "refresh-environment"
        description = "Refreshes environment settings and PowerShell profile"
        script = "setup-scripts/setup-environment.ps1"
        runElevated = $true
        runOnce = $false
    }
)

# Define script definitions for catalog.json
$scriptDefinitions = @(
    @{
        name = "Master Setup"
        description = "Main setup script that orchestrates the entire Azure Dev Box configuration"
        scriptPath = "setup-scripts/master-setup.ps1"
        runAsUser = $true
        runElevated = $true
    },
    @{
        name = "Setup Files and Folders"
        description = "Creates standard file structure, templates, and example files for development"
        scriptPath = "setup-scripts/setup-files-folders.ps1"
        runAsUser = $true
        runElevated = $false
    },
    @{
        name = "Install Developer Tools"
        description = "Installs common developer tools, languages, and applications"
        scriptPath = "setup-scripts/install-tools.ps1"
        runAsUser = $true
        runElevated = $true
    },
    @{
        name = "Configure Git"
        description = "Sets up Git configuration, aliases, and global gitignore"
        scriptPath = "setup-scripts/git-configuration.ps1"
        runAsUser = $true
        runElevated = $false
    },
    @{
        name = "Configure VS Code"
        description = "Installs VS Code extensions and sets up optimal development settings"
        scriptPath = "setup-scripts/vscode-configuration.ps1"
        runAsUser = $true
        runElevated = $false
    },
    @{
        name = "Setup Environment"
        description = "Configures environment variables, PowerShell profile, and project structures"
        scriptPath = "setup-scripts/setup-environment.ps1"
        runAsUser = $true
        runElevated = $true
    }
)

# Get paths to catalog.json and devbox-task.json
$repoRoot = Split-Path -Parent $PSScriptRoot
$catalogJsonPath = Join-Path -Path $repoRoot -ChildPath "catalog.json"
$devboxTaskJsonPath = Join-Path -Path $repoRoot -ChildPath "devbox-task.json"

# Update catalog.json
$catalogJson = Get-Content -Path $catalogJsonPath -Raw | ConvertFrom-Json
$catalogJson.scripts = $scriptDefinitions
$catalogJson.tasks = $taskDefinitions
$catalogJson.metadata.lastUpdated = (Get-Date -Format "yyyy-MM-dd")

# Update devbox-task.json
$devboxTaskJson = @{
    version = "1.0"
    tasks = $taskDefinitions
}

# Save the updated files
$catalogJson | ConvertTo-Json -Depth 10 | Out-File -FilePath $catalogJsonPath -Encoding utf8
$devboxTaskJson | ConvertTo-Json -Depth 10 | Out-File -FilePath $devboxTaskJsonPath -Encoding utf8

Write-Host "Task definitions updated successfully!" -ForegroundColor Green