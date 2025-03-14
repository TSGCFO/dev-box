# Script to install development tools for Azure Dev Box

Write-Host "Installing development tools for Azure Dev Box..." -ForegroundColor Cyan

# Install Chocolatey if not already installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
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
        { "PackageIdentifier": "Microsoft.DotNet.SDK.7" },
        { "PackageIdentifier": "Python.Python.3.11" },
        { "PackageIdentifier": "OpenJS.NodeJS.LTS" }
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
choco install git vscode nodejs python docker-desktop azure-cli powershell-core -y

# Install Python packages
Write-Host "Installing Python packages..." -ForegroundColor Yellow
pip install --upgrade pip
pip install black pytest pylint flake8 mypy django djangorestframework requests python-dotenv pandas numpy matplotlib jupyter

# Install Node.js packages globally
Write-Host "Installing Node.js packages..." -ForegroundColor Yellow
npm install -g typescript ts-node nodemon prettier eslint webpack webpack-cli create-react-app @vue/cli next

# Install Azure PowerShell modules
Write-Host "Installing Azure PowerShell modules..." -ForegroundColor Yellow
if (!(Get-Module -ListAvailable -Name Az)) {
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
}

# Install GitHub CLI
Write-Host "Installing GitHub CLI..." -ForegroundColor Yellow
winget install GitHub.cli --accept-source-agreements --accept-package-agreements

Write-Host "Development tools installation complete!" -ForegroundColor Green