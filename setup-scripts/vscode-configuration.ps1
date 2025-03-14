# Script to configure VS Code for Azure Dev Box

Write-Host "Setting up VS Code configuration..." -ForegroundColor Cyan

# Check if VS Code is installed
if (!(Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "VS Code is not installed. Installing VS Code..." -ForegroundColor Yellow
    winget install Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements
    # Refresh environment variables to get code command
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Create VS Code config directory
$vsCodeConfigDir = "C:\Projects\Config\VSCode"
if (!(Test-Path -Path $vsCodeConfigDir)) {
    New-Item -Path $vsCodeConfigDir -ItemType Directory -Force
}

# Define paths to source files in the repository
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$vsCodeExtDir = Join-Path -Path $repoRoot -ChildPath "vscode-extensions"
$settingsPath = Join-Path -Path $vsCodeExtDir -ChildPath "settings.json"
$keybindingsPath = Join-Path -Path $vsCodeExtDir -ChildPath "keybindings.json"
$installExtensionsPath = Join-Path -Path $vsCodeExtDir -ChildPath "install-extensions.ps1"

# Copy settings and keybindings to config directory
Copy-Item -Path $settingsPath -Destination "$vsCodeConfigDir\settings.json" -Force
Copy-Item -Path $keybindingsPath -Destination "$vsCodeConfigDir\keybindings.json" -Force

# Copy settings to VS Code user directory
$vsCodeUserDir = "$env:APPDATA\Code\User"
if (!(Test-Path -Path $vsCodeUserDir)) {
    New-Item -Path $vsCodeUserDir -ItemType Directory -Force
}

Copy-Item -Path $settingsPath -Destination "$vsCodeUserDir\settings.json" -Force
Copy-Item -Path $keybindingsPath -Destination "$vsCodeUserDir\keybindings.json" -Force

# Install extensions using the centralized script
Write-Host "Installing VS Code extensions..." -ForegroundColor Yellow
& $installExtensionsPath

Write-Host "VS Code configuration complete!" -ForegroundColor Green