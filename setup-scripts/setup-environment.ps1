# Script to set up development environment configuration

Write-Host "Setting up development environment configuration..." -ForegroundColor Cyan

# Create configuration directories
$configDirs = @(
    "C:\Projects\Config\VSCode",
    "C:\Projects\Config\Git",
    "C:\Projects\Config\NodeJS",
    "C:\Projects\Config\Python",
    "C:\Projects\Templates\ModelServer"
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

# Create VS Code settings
$vsCodeSettings = @"
{
    "editor.formatOnSave": true,
    "editor.tabSize": 4,
    "editor.renderWhitespace": "all",
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    "python.linting.pylintEnabled": true,
    "python.formatting.provider": "black",
    "git.autofetch": true,
    "terminal.integrated.defaultProfile.windows": "PowerShell"
}
"@

$vsCodeSettings | Out-File -FilePath "C:\Projects\Config\VSCode\settings.json" -Encoding utf8

Write-Host "Environment configuration complete!" -ForegroundColor Green
