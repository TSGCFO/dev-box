# Simple script to check if setup completed successfully

Write-Host "Checking setup progress..." -ForegroundColor Cyan

# Check if main Projects directory exists
if (Test-Path -Path "C:\Projects") {
    Write-Host "✓ Main Projects directory exists" -ForegroundColor Green
    
    # Check subdirectories
    $subDirs = @(
        "WebApps", "APIs", "Scripts", "Libraries", "Templates", "Config", "Data"
    )
    
    foreach ($dir in $subDirs) {
        $path = "C:\Projects\$dir"
        if (Test-Path -Path $path) {
            Write-Host "✓ $dir directory exists" -ForegroundColor Green
        } else {
            Write-Host "✗ $dir directory does not exist" -ForegroundColor Red
        }
    }
    
    # Check API template
    if (Test-Path -Path "C:\Projects\Templates\API\package.json") {
        Write-Host "✓ API template package.json exists" -ForegroundColor Green
    } else {
        Write-Host "✗ API template package.json does not exist" -ForegroundColor Red
    }
    
    if (Test-Path -Path "C:\Projects\Templates\API\src\index.js") {
        Write-Host "✓ API template index.js exists" -ForegroundColor Green
    } else {
        Write-Host "✗ API template index.js does not exist" -ForegroundColor Red
    }
    
    # Check React template
    if (Test-Path -Path "C:\Projects\Templates\ReactApp\src\index.js") {
        Write-Host "✓ React template index.js exists" -ForegroundColor Green
    } else {
        Write-Host "✗ React template index.js does not exist" -ForegroundColor Red
    }
    
    # Check README
    if (Test-Path -Path "C:\Projects\README.md") {
        Write-Host "✓ Projects README.md exists" -ForegroundColor Green
    } else {
        Write-Host "✗ Projects README.md does not exist" -ForegroundColor Red
    }
    
} else {
    Write-Host "✗ Main Projects directory does not exist" -ForegroundColor Red
    Write-Host "Setup appears to have failed or is still in progress" -ForegroundColor Yellow
}

# Check environment variables
$envVars = @(
    "NODE_ENV", "PYTHONPATH", "EDITOR", "PROJECTS_ROOT"
)

Write-Host "`nChecking environment variables:" -ForegroundColor Cyan
foreach ($var in $envVars) {
    $value = [Environment]::GetEnvironmentVariable($var, "User")
    if ($value) {
        Write-Host "✓ $var = $value" -ForegroundColor Green
    } else {
        Write-Host "✗ $var not set" -ForegroundColor Red
    }
}

Write-Host "`nSetup check complete" -ForegroundColor Cyan