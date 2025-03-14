# Script to configure Git settings for Azure Dev Box

Write-Host "Setting up Git configuration..." -ForegroundColor Cyan

# Create Git config directory
$gitConfigDir = "C:\Projects\Config\Git"
if (!(Test-Path -Path $gitConfigDir)) {
    New-Item -Path $gitConfigDir -ItemType Directory -Force
}

# Check if git is installed
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed. Installing Git..." -ForegroundColor Yellow
    winget install Git.Git --accept-source-agreements --accept-package-agreements
    # Refresh environment variables to get git command
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
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
$gitignoreContent = @"
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Node.js
node_modules/
npm-debug.log
yarn-error.log
package-lock.json
yarn.lock
.pnp/
.pnp.js
.npm/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg
.env
.venv
venv/
ENV/
.pytest_cache/
pytestdebug.log

# Java
*.class
*.log
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar
hs_err_pid*
.gradle/
.mvn/
target/

# .NET
bin/
obj/
.vs/
_ReSharper*/
*.resharper
*.suo
*.user
*.userosscache
*.sln.docstates
packages/

# IDEs and editors
.idea/
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.swp
*.swo
*~
.project
.classpath
.settings/
.history/

# Environment files
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Azure
.azure/
servicebus.json
appsettings.*.json
local.settings.json

# Misc
.cache/
.temp/
.tmp/
coverage/
.coverage
"@

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