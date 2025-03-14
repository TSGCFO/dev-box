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
    "C:\Projects\Tools",
    "$env:APPDATA\npm",                                  # NPM global packages
    "$env:LOCALAPPDATA\Programs\Python\Python311",       # Python 3.11
    "$env:LOCALAPPDATA\Programs\Python\Python311\Scripts", # Python 3.11 Scripts
    "$env:LOCALAPPDATA\uv\bin",                          # UV Python package manager
    "$env:ProgramFiles\nodejs",                          # Node.js
    "$env:APPDATA\nvm",                                  # NVM for Windows
    "$env:USERPROFILE\AppData\Local\Microsoft\WinGet\Packages", # WinGet packages
    "$env:USERPROFILE\.cargo\bin"                        # Rust tools
)

foreach ($path in $newPaths) {
    if (!(Test-Path -Path $path -ErrorAction SilentlyContinue)) {
        try {
            New-Item -Path $path -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
        } catch {
            Write-Host "Could not create path: $path" -ForegroundColor Yellow
        }
    }
    
    if (!$currentPath.Contains($path)) {
        $currentPath = "$currentPath;$path"
    }
}

# Clean up any duplicate paths
$pathArray = $currentPath.Split(';') | Where-Object { $_ -ne "" } | Select-Object -Unique
$cleanPath = $pathArray -join ';'

[Environment]::SetEnvironmentVariable("PATH", $cleanPath, "User")

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
Set-Alias -Name np -Value notepad++.exe -ErrorAction SilentlyContinue
Set-Alias -Name py -Value python

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

# NVM shortcuts
function nvml { nvm list }
function nvmu { param([string]`$version) nvm use `$version }
function nvmi { param([string]`$version) nvm install `$version }

# Python shortcuts
function uvenv { 
    param([string]`$envName = ".venv")
    uv venv `$envName
    if (Test-Path -Path "`$envName\Scripts\Activate.ps1") {
        & "`$envName\Scripts\Activate.ps1"
    }
}
function cenv { 
    param([string]`$envName = ".venv")
    if (Test-Path -Path "`$envName\Scripts\Activate.ps1") {
        & "`$envName\Scripts\Activate.ps1"
    }
}

# Azure shortcuts
function azl { az login }
function azs { param([string]`$subscription) az account set --subscription `$subscription }
function azls { az account list --output table }
function azcr { param([string]`$rg) az configure --defaults group=`$rg }

# WSL shortcuts
function ub { wsl -d Ubuntu }
function suse { wsl -d openSUSE-Leap-15.5 }

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
Write-Host "NVM shortcuts: nvml, nvmu, nvmi" -ForegroundColor Green
Write-Host "Python shortcuts: uvenv, cenv" -ForegroundColor Green
Write-Host "Azure shortcuts: azl, azs, azls, azcr" -ForegroundColor Green
Write-Host "WSL shortcuts: ub (Ubuntu), suse (openSUSE)" -ForegroundColor Green
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
|  - nvml: List Node.js versions                          |
|  - uvenv: Create Python virtual env with uv             |
|  - ub: Open Ubuntu WSL                                  |
|  - suse: Open openSUSE WSL                              |
|                                                         |
+---------------------------------------------------------+
"@

# Check for installed tools
Write-Host "`nInstalled Tools:" -ForegroundColor Cyan

# Python
try {
    `$pythonVersion = python --version 2>&1
    Write-Host "Python: " -NoNewline
    Write-Host `$pythonVersion -ForegroundColor Green
} catch {
    Write-Host "Python: Not detected" -ForegroundColor Red
}

# Node.js
try {
    `$nodeVersion = node --version
    Write-Host "Node.js: " -NoNewline
    Write-Host `$nodeVersion -ForegroundColor Green
} catch {
    Write-Host "Node.js: Not detected" -ForegroundColor Red
}

# NVM
try {
    `$nvmVersion = nvm version
    Write-Host "NVM: " -NoNewline
    Write-Host `$nvmVersion -ForegroundColor Green
} catch {
    Write-Host "NVM: Not detected" -ForegroundColor Red
}

# UV
try {
    `$uvVersion = uv --version
    Write-Host "UV: " -NoNewline
    Write-Host `$uvVersion -ForegroundColor Green
} catch {
    Write-Host "UV: Not detected" -ForegroundColor Red
}

# WSL
try {
    `$wslDistros = wsl --list --verbose | Out-String
    if (`$wslDistros -match "Ubuntu") {
        Write-Host "Ubuntu WSL: Installed" -ForegroundColor Green
    } else {
        Write-Host "Ubuntu WSL: Not installed" -ForegroundColor Red
    }
    
    if (`$wslDistros -match "openSUSE") {
        Write-Host "openSUSE WSL: Installed" -ForegroundColor Green
    } else {
        Write-Host "openSUSE WSL: Not installed" -ForegroundColor Red
    }
} catch {
    Write-Host "WSL: Not detected" -ForegroundColor Red
}

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
Write-Host "Type 'np' to launch Notepad++." -ForegroundColor Cyan
Write-Host "Type 'uvenv' to create a new Python environment with UV." -ForegroundColor Cyan
Write-Host "Type 'ub' to launch Ubuntu WSL." -ForegroundColor Cyan
"@

$welcomeScriptPath = "C:\Projects\Scripts\welcome.ps1"
if (!(Test-Path -Path (Split-Path -Parent $welcomeScriptPath))) {
    New-Item -Path (Split-Path -Parent $welcomeScriptPath) -ItemType Directory -Force
}
$welcomeScript | Out-File -FilePath $welcomeScriptPath -Force -Encoding utf8

# Create scheduled task to run welcome script at logon
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Normal -ExecutionPolicy Bypass -File $welcomeScriptPath"
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

# Set up Python configuration
Write-Host "Setting up Python configuration..." -ForegroundColor Yellow
$pythonConfigDir = "C:\Projects\Config\Python"
if (!(Test-Path -Path $pythonConfigDir)) {
    New-Item -Path $pythonConfigDir -ItemType Directory -Force
}

# Create pip.ini for default pip configuration
$pipConfig = @"
[global]
trusted-host = pypi.python.org
               pypi.org
               files.pythonhosted.org
timeout = 60
"@

$pipConfigPath = "$pythonConfigDir\pip.ini"
$pipConfig | Out-File -FilePath $pipConfigPath -Force -Encoding utf8

# Create symbolic link to pip.ini in user directory
$userPipDir = "$env:APPDATA\pip"
if (!(Test-Path -Path $userPipDir)) {
    New-Item -Path $userPipDir -ItemType Directory -Force
}
Copy-Item -Path $pipConfigPath -Destination "$userPipDir\pip.ini" -Force

# Set up Node.js configuration
Write-Host "Setting up Node.js configuration..." -ForegroundColor Yellow
$nodeConfigDir = "C:\Projects\Config\NodeJS"
if (!(Test-Path -Path $nodeConfigDir)) {
    New-Item -Path $nodeConfigDir -ItemType Directory -Force
}

# Create .npmrc file for npm configuration
$npmConfig = @"
registry=https://registry.npmjs.org/
save=true
save-exact=false
init-author-name=
init-author-email=
init-license=MIT
"@

$npmConfigPath = "$nodeConfigDir\.npmrc"
$npmConfig | Out-File -FilePath $npmConfigPath -Force -Encoding utf8

# Create symbolic link to .npmrc in user directory
Copy-Item -Path $npmConfigPath -Destination "$env:USERPROFILE\.npmrc" -Force

Write-Host "Azure Dev Box environment configuration complete!" -ForegroundColor Green