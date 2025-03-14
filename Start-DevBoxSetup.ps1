# Start script for Dev Box Setup
# This is the entry point for the Dev Box setup process

# Check if script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $scriptPath = $MyInvocation.MyCommand.Path
    $setupUiPath = Join-Path -Path $PSScriptRoot -ChildPath "setup-scripts\dev-box-ui.ps1"
    
    Write-Host "This script requires administrator privileges. Restarting as administrator..." -ForegroundColor Yellow
    
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$setupUiPath`"" -Verb RunAs
    return
}

# Run the setup UI script
$setupUiPath = Join-Path -Path $PSScriptRoot -ChildPath "setup-scripts\dev-box-ui.ps1"
& $setupUiPath