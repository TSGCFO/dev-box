# Script to configure Git settings for Azure Dev Box

Write-Host "Setting up Git configuration..." -ForegroundColor Cyan

# Create Git config directory
$gitConfigDir = "C:\Projects\Config\Git"
if (!(Test-Path -Path $gitConfigDir)) {
    New-Item -Path $gitConfigDir -ItemType Directory -Force
}

# Source the centralized configuration
. $PSScriptRoot\config-definitions.ps1

# Check if git is installed using the centralized tool check function
$gitStatus = Test-ToolInstallation -CommandName "git"
if (!$gitStatus.Installed) {
    Write-Host "Git is not installed. Git should be installed via install-tools.ps1 first." -ForegroundColor Yellow
    Write-Host "Continuing with configuration assuming Git will be installed separately..." -ForegroundColor Yellow
}

# Retrieve Git user information from environment or prompt user
$gitName = $env:GIT_USERNAME
$gitEmail = $env:GIT_EMAIL

if ([string]::IsNullOrEmpty($gitName)) {
    $gitName = Read-Host -Prompt "Enter your Git username"
}

if ([string]::IsNullOrEmpty($gitEmail)) {
    $gitEmail = Read-Host -Prompt "Enter your Git email"
}

# Configure Git globally
Write-Host "Configuring Git global settings..." -ForegroundColor Yellow
git config --global user.name "$gitName"
git config --global user.email "$gitEmail"
git config --global init.defaultBranch main
git config --global core.autocrlf input
git config --global core.editor "code --wait"
git config --global pull.rebase false
git config --global push.autoSetupRemote true

# Set up Git aliases
Write-Host "Setting up Git aliases..." -ForegroundColor Yellow
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.visual "!gitk"
git config --global alias.df "diff --word-diff=color"

# Create global .gitignore file
Write-Host "Creating global .gitignore file..." -ForegroundColor Yellow
# Source the centralized configuration
. $PSScriptRoot\config-definitions.ps1
$gitignoreContent = Get-GitIgnoreContent

$gitignoreContent | Out-File -FilePath "$gitConfigDir\.gitignore_global" -Encoding utf8
git config --global core.excludesfile "$gitConfigDir\.gitignore_global"

# Setup Git credential manager
git config --global credential.helper manager-core

# Configure Git for Azure DevOps if needed
$useAzureDevOps = Read-Host -Prompt "Do you want to configure Git for Azure DevOps? (y/n)"
if ($useAzureDevOps -eq "y") {
    $orgName = Read-Host -Prompt "Enter your Azure DevOps organization name"
    git config --global credential.https://dev.azure.com.$orgName.useHttpPath true
}

Write-Host "Git configuration complete!" -ForegroundColor Green