# Script to set up development environment configuration for Azure Dev Box

Write-Host "Setting up Azure Dev Box environment configuration..." -ForegroundColor Cyan

# Create configuration directories
$configDirs = @(
    "C:\Projects\Config\VSCode",
    "C:\Projects\Config\Git",
    "C:\Projects\Config\NodeJS",
    "C:\Projects\Config\Python",
    "C:\Projects\Config\Azure",
    "C:\Projects\Config\Docker",
    "C:\Projects\Config\PowerShell",
    "C:\Projects\Templates"
)

foreach ($dir in $configDirs) {
    if (!(Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force
        Write-Host "Created directory: $dir" -ForegroundColor Green
    }
}

# Set up environment variables for development
Write-Host "Setting up environment variables..." -ForegroundColor Cyan

# Common development environment variables
[Environment]::SetEnvironmentVariable("NODE_ENV", "development", "User")
[Environment]::SetEnvironmentVariable("PYTHONPATH", "C:\Projects", "User")
[Environment]::SetEnvironmentVariable("EDITOR", "code", "User")
[Environment]::SetEnvironmentVariable("PROJECTS_ROOT", "C:\Projects", "User")

# Add custom directories to PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$newPaths = @(
    "C:\Projects\Scripts",
    "C:\Projects\Tools"
)

foreach ($path in $newPaths) {
    if (!(Test-Path -Path $path)) {
        New-Item -Path $path -ItemType Directory -Force
    }
    
    if (!$currentPath.Contains($path)) {
        $currentPath = "$currentPath;$path"
    }
}

[Environment]::SetEnvironmentVariable("PATH", $currentPath, "User")

# Create PowerShell profile
Write-Host "Setting up PowerShell profile..." -ForegroundColor Yellow
$profileContent = @"
# Azure Dev Box PowerShell Profile

function prompt {
    `$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    `$principal = [Security.Principal.WindowsPrincipal] `$identity
    `$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    `$prefix = ""
    if (`$principal.IsInRole(`$adminRole)) {
        `$prefix = "[ADMIN] "
    }

    `$currentPath = Get-Location
    `$projectsPath = "C:\Projects"
    
    if (`$currentPath.Path.StartsWith(`$projectsPath)) {
        `$relativePath = `$currentPath.Path.Substring(`$projectsPath.Length)
        `$shortPath = "Projects" + `$relativePath
    } else {
        `$shortPath = Split-Path -Leaf -Path `$currentPath
    }

    Write-Host "`n" -NoNewline
    Write-Host `$prefix -NoNewline -ForegroundColor Red
    Write-Host "PS " -NoNewline -ForegroundColor Blue
    Write-Host `$shortPath -NoNewline -ForegroundColor Yellow
    Write-Host " >" -NoNewline -ForegroundColor Green
    return " "
}

# Aliases
Set-Alias -Name g -Value git
Set-Alias -Name code -Value code-insiders -ErrorAction SilentlyContinue

# Common Functions
function cdp { Set-Location -Path "C:\Projects" }
function cdw { Set-Location -Path "C:\Projects\WebApps" }
function cds { Set-Location -Path "C:\Projects\Scripts" }
function cdl { Set-Location -Path "C:\Projects\Libraries" }
function cdt { Set-Location -Path "C:\Projects\Templates" }

# Git shortcuts
function gst { git status }
function gcm { param([string]`$message) git commit -m `$message }
function gaa { git add --all }
function gpl { git pull }
function gps { git push }
function gnb { param([string]`$branch) git checkout -b `$branch }

# Azure shortcuts
function azl { az login }
function azs { param([string]`$subscription) az account set --subscription `$subscription }
function azls { az account list --output table }
function azcr { param([string]`$rg) az configure --defaults group=`$rg }

# Use PSReadLine for better command line editing
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# Load Azure DevOps module if available
if (Get-Module -ListAvailable -Name Az) {
    # Don't show deprecation warnings
    Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"
}

# Welcome message
Write-Host "Azure Dev Box PowerShell Environment" -ForegroundColor Cyan
Write-Host "Project shortcuts: cdp, cdw, cds, cdl, cdt" -ForegroundColor Green
Write-Host "Git shortcuts: gst, gcm, gaa, gpl, gps, gnb" -ForegroundColor Green
Write-Host "Azure shortcuts: azl, azs, azls, azcr" -ForegroundColor Green
"@

$documentsPath = [Environment]::GetFolderPath('MyDocuments')
$powershellPath = Join-Path -Path $documentsPath -ChildPath "WindowsPowerShell"

if (!(Test-Path -Path $powershellPath)) {
    New-Item -Path $powershellPath -ItemType Directory -Force
}

$profilePath = Join-Path -Path $powershellPath -ChildPath "Microsoft.PowerShell_profile.ps1"
$profileContent | Out-File -FilePath $profilePath -Force -Encoding utf8

# Create a welcome screen for Dev Box
$welcomeScript = @"
# Azure Dev Box Welcome Script
# This script runs when the Dev Box is started

Clear-Host
Write-Host @"
+---------------------------------------------------------+
|                                                         |
|                   AZURE DEV BOX                         |
|                                                         |
+---------------------------------------------------------+
|                                                         |
|  Your development environment is ready!                 |
|                                                         |
|  - Project folders are in C:\Projects                   |
|  - Configuration files are in C:\Projects\Config        |
|  - Scripts are in C:\Projects\Scripts                   |
|                                                         |
|  Shortcuts in PowerShell:                               |
|  - cdp: Go to Projects folder                           |
|  - gst: Git status                                      |
|  - azl: Azure login                                     |
|                                                         |
+---------------------------------------------------------+
"@

# Check for Azure login status
try {
    `$azAccount = az account show 2>$null | ConvertFrom-Json
    if (`$azAccount) {
        Write-Host "`nYou are logged in to Azure as: " -NoNewline
        Write-Host `$azAccount.user.name -ForegroundColor Green
        Write-Host "Subscription: " -NoNewline
        Write-Host `$azAccount.name -ForegroundColor Green
    } else {
        Write-Host "`nYou are not logged into Azure. Run 'az login' to connect." -ForegroundColor Yellow
    }
} catch {
    Write-Host "`nAzure CLI not detected or you're not logged in. Run 'az login' to connect." -ForegroundColor Yellow
}

# Check for Git configuration
try {
    `$gitUser = git config --global user.name
    `$gitEmail = git config --global user.email
    
    if (`$gitUser -and `$gitEmail) {
        Write-Host "`nGit is configured for: " -NoNewline
        Write-Host "`$gitUser <`$gitEmail>" -ForegroundColor Green
    } else {
        Write-Host "`nGit is not fully configured. Run the Git configuration script." -ForegroundColor Yellow
    }
} catch {
    Write-Host "`nGit not detected or not configured. Run the Git configuration script." -ForegroundColor Yellow
}

Write-Host "`nType 'code' to launch Visual Studio Code." -ForegroundColor Cyan
"@

$welcomeScriptPath = "C:\Projects\Scripts\welcome.ps1"
$welcomeScript | Out-File -FilePath $welcomeScriptPath -Force -Encoding utf8

# Create scheduled task to run welcome script at logon
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File $welcomeScriptPath"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

if (Get-ScheduledTask -TaskName "DevBoxWelcome" -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName "DevBoxWelcome" -Confirm:$false
}

Register-ScheduledTask -TaskName "DevBoxWelcome" -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Display welcome message when logging into Dev Box"

# Docker configuration if Docker is installed
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "Setting up Docker configuration..." -ForegroundColor Yellow
    
    # Create directory for Docker configuration
    $dockerConfigDir = "C:\Projects\Config\Docker"
    if (!(Test-Path -Path $dockerConfigDir)) {
        New-Item -Path $dockerConfigDir -ItemType Directory -Force
    }
    
    # Configure Docker to use WSL 2
    $dockerConfig = @"
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "features": {
    "buildkit": true
  },
  "wsl-ubuntu": {
    "enabled": true
  }
}
"@
    
    $dockerConfigPath = "$env:USERPROFILE\.docker\config.json"
    $dockerConfigDir = Split-Path -Parent $dockerConfigPath
    
    if (!(Test-Path -Path $dockerConfigDir)) {
        New-Item -Path $dockerConfigDir -ItemType Directory -Force
    }
    
    $dockerConfig | Out-File -FilePath $dockerConfigPath -Force -Encoding utf8
}

Write-Host "Azure Dev Box environment configuration complete!" -ForegroundColor Green