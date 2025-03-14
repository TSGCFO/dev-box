# Script to configure VS Code
# Place in C:\DevBoxSetup\setup-vscode.ps1

Write-Host "Setting up VS Code configuration..." -ForegroundColor Cyan

# Create VS Code config directory
$vsCodeConfigDir = "C:\Projects\Config\VSCode"
if (!(Test-Path -Path $vsCodeConfigDir)) {
    New-Item -Path $vsCodeConfigDir -ItemType Directory -Force
}

# Create VS Code settings.json
$vsCodeSettings = @"
{
    "editor.formatOnSave": true,
    "editor.tabSize": 4,
    "editor.renderWhitespace": "all",
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    "workbench.colorTheme": "Default Dark Modern",
    "terminal.integrated.defaultProfile.windows": "PowerShell",
    
    // Python settings
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "python.formatting.provider": "black",
    
    // JavaScript settings
    "javascript.updateImportsOnFileMove.enabled": "always",
    "typescript.updateImportsOnFileMove.enabled": "always",
    
    // Git settings
    "git.autofetch": true,
    "git.confirmSync": false
}
"@

$vsCodeSettings | Out-File -FilePath "$vsCodeConfigDir\settings.json" -Encoding utf8

# Install VS Code extensions
$extensions = @(
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-azuretools.vscode-docker",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-vscode.powershell",
    "github.copilot",
    "mhutchie.git-graph"
)

foreach ($extension in $extensions) {
    Write-Host "Installing VS Code extension: $extension" -ForegroundColor Yellow
    code --install-extension $extension
}

# Copy settings to VS Code user directory
$vsCodeUserDir = "$env:APPDATA\Code\User"
if (!(Test-Path -Path $vsCodeUserDir)) {
    New-Item -Path $vsCodeUserDir -ItemType Directory -Force
}

Copy-Item -Path "$vsCodeConfigDir\settings.json" -Destination "$vsCodeUserDir\settings.json" -Force

Write-Host "VS Code configuration complete!" -ForegroundColor Green
