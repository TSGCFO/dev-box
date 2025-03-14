# Master script to set up the entire development environment
# Place in C:\DevBoxSetup\master-setup.ps1

Write-Host "Starting development environment setup..." -ForegroundColor Cyan

# Step 1: Set up project directory structure
Write-Host "Step 1: Setting up project directory structure..." -ForegroundColor Yellow
$projectFolders = @(
    "C:\Projects",
    "C:\Projects\ModelServers",
    "C:\Projects\WebApps",
    "C:\Projects\Scripts",
    "C:\Projects\Libraries",
    "C:\Projects\Experiments",
    "C:\Projects\Documentation",
    "C:\Projects\Config",
    "C:\Projects\Templates"
)

foreach ($folder in $projectFolders) {
    if (!(Test-Path -Path $folder)) {
        New-Item -Path $folder -ItemType Directory -Force
        Write-Host "Created folder: $folder" -ForegroundColor Green
    }
}

# Step 2: Set up Model Server templates
Write-Host "Step 2: Setting up Model Server templates..." -ForegroundColor Yellow
. .\setup-model-templates.ps1

# Step 3: Configure Git
Write-Host "Step 3: Configuring Git..." -ForegroundColor Yellow
. .\setup-git.ps1

# Step 4: Configure VS Code
Write-Host "Step 4: Configuring VS Code..." -ForegroundColor Yellow
. .\setup-vscode.ps1

# Step 5: Set up environment variables
Write-Host "Step 5: Setting up environment variables..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("NODE_ENV", "development", "User")
[Environment]::SetEnvironmentVariable("PYTHONPATH", "C:\Projects", "User")
[Environment]::SetEnvironmentVariable("EDITOR", "code", "User")
[Environment]::SetEnvironmentVariable("PROJECTS_ROOT", "C:\Projects", "User")

Write-Host "Development environment setup complete!" -ForegroundColor Green
Write-Host "Your developer box is ready for use." -ForegroundColor Cyan

# Show summary of what was set up
Write-Host "`nSummary of Setup:" -ForegroundColor Yellow
Write-Host "- Project structure created at C:\Projects"
Write-Host "- Model Server templates installed"
Write-Host "- Git configured with aliases and global gitignore"
Write-Host "- VS Code configured with settings and extensions"
Write-Host "- Environment variables set"

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Clone your repositories into the appropriate folders"
Write-Host "2. Use the Model Server templates to create new servers"
Write-Host "3. Review the VS Code settings and customize as needed"
