# Script to install development tools for Azure Dev Box

Write-Host "Installing development tools for Azure Dev Box..." -ForegroundColor Cyan

# Install Chocolatey if not already installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh environment variables to get choco command
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Create Winget config file for additional tools
$wingetConfig = @"
{
  "$$schema": "https://aka.ms/winget-packages.schema.2.0.json",
  "CreationDate": "2025-03-14",
  "Sources": [
    {
      "SourceDetails": {
        "Name": "winget",
        "Identifier": "Microsoft.Winget.Source_8wekyb3d8bbwe",
        "Argument": "",
        "Type": "Microsoft.PreIndexed.Package"
      },
      "Packages": [
        { "PackageIdentifier": "Postman.Postman" },
        { "PackageIdentifier": "Microsoft.PowerToys" },
        { "PackageIdentifier": "Microsoft.AzureCLI" },
        { "PackageIdentifier": "Microsoft.PowerShell" },
        { "PackageIdentifier": "Microsoft.VisualStudioCode" },
        { "PackageIdentifier": "Git.Git" },
        { "PackageIdentifier": "Docker.DockerDesktop" },
        { "PackageIdentifier": "Python.Python.3.11" },
        { "PackageIdentifier": "OpenJS.NodeJS.LTS" },
        { "PackageIdentifier": "Anthropic.Claude" },
        { "PackageIdentifier": "Anthropic.ClaudeCode" },
        { "PackageIdentifier": "OpenAI.ChatGPT" },
        { "PackageIdentifier": "PostgreSQL.PostgreSQL" },
        { "PackageIdentifier": "Google.Chrome" },
        { "PackageIdentifier": "Notepad++.Notepad++" },
        { "PackageIdentifier": "Microsoft.WindowsTerminal" }
      ]
    }
  ]
}
"@

$wingetConfigPath = "$PSScriptRoot\devbox-tools.json"
$wingetConfig | Out-File -FilePath $wingetConfigPath -Encoding utf8

# Install tools using Winget
Write-Host "Installing applications using Winget..." -ForegroundColor Yellow
winget import -i $wingetConfigPath --accept-package-agreements --accept-source-agreements --ignore-unavailable

# Install common dev tools with Chocolatey (in case Winget fails)
Write-Host "Installing applications using Chocolatey (backup method)..." -ForegroundColor Yellow
choco install git vscode nodejs python311 docker-desktop azure-cli powershell-core postgresql googlechrome notepadplusplus powertoys -y

# Install ClaudeMind using direct download if available
Write-Host "Installing ClaudeMind..." -ForegroundColor Yellow
$claudeMindInstallerUrl = "https://cdn.anthropic.com/claude-desktop/windows/stable/ClaudeDesktopSetup.exe"
$claudeMindInstallerPath = "$env:TEMP\ClaudeDesktopSetup.exe"

try {
    Invoke-WebRequest -Uri $claudeMindInstallerUrl -OutFile $claudeMindInstallerPath
    Start-Process -FilePath $claudeMindInstallerPath -ArgumentList "/S" -Wait
    Write-Host "ClaudeMind installation completed" -ForegroundColor Green
} catch {
    Write-Host "Could not automatically install ClaudeMind. Please install manually." -ForegroundColor Yellow
}

# Install Node Version Manager (nvm) for Windows
Write-Host "Installing Node Version Manager (nvm)..." -ForegroundColor Yellow
$nvmInstallerUrl = "https://github.com/coreybutler/nvm-windows/releases/download/1.1.11/nvm-setup.exe"
$nvmInstallerPath = "$env:TEMP\nvm-setup.exe"

try {
    Invoke-WebRequest -Uri $nvmInstallerUrl -OutFile $nvmInstallerPath
    Start-Process -FilePath $nvmInstallerPath -ArgumentList "/SILENT" -Wait
    Write-Host "NVM for Windows installation completed" -ForegroundColor Green
    
    # Refresh environment variables to get nvm command
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Install specific Node.js versions
    nvm install 18.19.0
    nvm install 20.10.0
    nvm use 20.10.0
} catch {
    Write-Host "Could not automatically install NVM. Please install manually." -ForegroundColor Yellow
}

# Install Python packages and uv
Write-Host "Installing Python packages and uv..." -ForegroundColor Yellow
pip install --upgrade pip
pip install uv
pip install black pytest pylint flake8 mypy django djangorestframework requests python-dotenv pandas numpy matplotlib jupyter

# Add uv to PATH explicitly
$uvPath = "$env:LOCALAPPDATA\uv\bin"
if (!(Test-Path -Path $uvPath)) {
    New-Item -Path $uvPath -ItemType Directory -Force
}
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if (!$currentPath.Contains($uvPath)) {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$uvPath", "User")
}

# Install Node.js packages globally
Write-Host "Installing Node.js packages..." -ForegroundColor Yellow
npm install -g typescript ts-node nodemon prettier eslint webpack webpack-cli create-react-app @vue/cli next

# Install WSL and Linux distributions
Write-Host "Installing WSL and Linux distributions..." -ForegroundColor Yellow
wsl --install --no-distribution

Write-Host "Installing Ubuntu WSL distribution..." -ForegroundColor Yellow
wsl --install -d Ubuntu

Write-Host "Installing openSUSE WSL distribution..." -ForegroundColor Yellow
wsl --install -d openSUSE-Leap-15.5

# Enable Hyper-V and Virtual Machine Platform if needed for WSL
Write-Host "Enabling Hyper-V and Virtual Machine Platform..." -ForegroundColor Yellow
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

# Install Azure PowerShell modules
Write-Host "Installing Azure PowerShell modules..." -ForegroundColor Yellow
if (!(Get-Module -ListAvailable -Name Az)) {
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
}

# Install GitHub CLI
Write-Host "Installing GitHub CLI..." -ForegroundColor Yellow
winget install GitHub.cli --accept-source-agreements --accept-package-agreements

Write-Host "Development tools installation complete!" -ForegroundColor Green