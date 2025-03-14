# Script to install additional development tools

Write-Host "Installing additional development tools..." -ForegroundColor Cyan

# Create Winget config file for additional tools
$wingetConfig = @"
{
  "$schema": "https://aka.ms/winget-packages.schema.2.0.json",
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
        { "PackageIdentifier": "PostgreSQL.PostgreSQL" }
      ]
    }
  ]
}
"@

$wingetConfig | Out-File -FilePath "$PSScriptRoot\additional-tools.json" -Encoding utf8

# Install tools using Winget
winget import -i "$PSScriptRoot\additional-tools.json" --accept-package-agreements

# Install Python packages
Write-Host "Installing Python packages..." -ForegroundColor Cyan
pip install black pytest pylint django djangorestframework requests python-dotenv pandas numpy matplotlib

# Install Node.js packages globally
Write-Host "Installing Node.js packages..." -ForegroundColor Cyan
npm install -g typescript ts-node nodemon prettier eslint

Write-Host "Additional tools installation complete!" -ForegroundColor Green
