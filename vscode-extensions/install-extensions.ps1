# Script to install VS Code extensions for development

Write-Host "Installing recommended VS Code extensions..." -ForegroundColor Cyan

# Read extensions from the central extensions.json file
$extensionsJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "extensions.json"
$extensionsJson = Get-Content -Path $extensionsJsonPath -Raw | ConvertFrom-Json
$extensions = $extensionsJson.recommendations

# Install extensions
foreach ($extension in $extensions) {
    Write-Host "Installing: $extension" -ForegroundColor Yellow
    code --install-extension $extension
}

Write-Host "VS Code extensions installation complete!" -ForegroundColor Green