# Comprehensive script to fix and validate dev box setup

Write-Host "Starting comprehensive dev box environment setup..." -ForegroundColor Cyan

# 1. Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "WARNING: This script should be run as Administrator for full functionality." -ForegroundColor Yellow
    Write-Host "Some operations might fail without administrative privileges." -ForegroundColor Yellow
    $continue = Read-Host "Do you want to continue anyway? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        Write-Host "Exiting script. Please restart with administrative privileges." -ForegroundColor Red
        exit
    }
}

# 2. Load config definitions
if (Test-Path -Path ".\setup-scripts\config-definitions.ps1") {
    . .\setup-scripts\config-definitions.ps1
    Write-Host "Loaded configuration definitions." -ForegroundColor Green
} else {
    Write-Host "Configuration definitions not found. Creating default configuration..." -ForegroundColor Yellow
    
    # Define default configuration
    $script:ProjectsRoot = "C:\Projects"
    $script:ConfigRoot = "C:\Projects\Config"
    $script:TemplatesRoot = "C:\Projects\Templates"
    
    # Path directories that should be added to PATH
    $script:PathDirectories = @(
        "C:\Projects\Scripts",
        "C:\Projects\Tools",
        "$env:APPDATA\npm",                                  # NPM global packages
        "$env:LOCALAPPDATA\Programs\Python\Python311",       # Python 3.11
        "$env:LOCALAPPDATA\Programs\Python\Python311\Scripts", # Python 3.11 Scripts
        "$env:LOCALAPPDATA\uv\bin",                          # UV Python package manager
        "$env:ProgramFiles\nodejs",                          # Node.js
        "$env:APPDATA\nvm",                                  # NVM for Windows
        "$env:USERPROFILE\AppData\Local\Microsoft\WinGet\Packages", # WinGet packages
        "$env:USERPROFILE\.cargo\bin",                       # Rust tools
        "$env:ProgramData\chocolatey\lib\ngrok\tools",        # Ngrok from Chocolatey
        "C:\ProgramData\ngrok"                               # Ngrok default location
    )
    
    # Environment variables that should be set
    $script:EnvironmentVariables = @{
        "NODE_ENV" = "development"
        "PYTHONPATH" = "C:\Projects"
        "EDITOR" = "code"
        "PROJECTS_ROOT" = "C:\Projects"
    }
}

# 3. Verify and create project directory structure
Write-Host "Checking and creating project directory structure..." -ForegroundColor Cyan

# Define comprehensive project folders list
$comprehensiveProjectFolders = @(
    # Main project directories
    "C:\Projects",
    "C:\Projects\WebApps",
    "C:\Projects\APIs",
    "C:\Projects\Mobile",
    "C:\Projects\Desktop",
    "C:\Projects\Scripts",
    "C:\Projects\Libraries",
    "C:\Projects\Tools",
    "C:\Projects\ML",
    "C:\Projects\AI",
    "C:\Projects\Cloud",
    "C:\Projects\DevOps",
    "C:\Projects\Documentation",
    "C:\Projects\Config",
    "C:\Projects\Templates",
    "C:\Projects\Research",
    "C:\Projects\Data",
    
    # Configuration directories
    "C:\Projects\Config\VSCode",
    "C:\Projects\Config\Git",
    "C:\Projects\Config\NodeJS",
    "C:\Projects\Config\Python",
    "C:\Projects\Config\Azure",
    "C:\Projects\Config\Docker",
    "C:\Projects\Config\PowerShell",
    "C:\Projects\Config\WSL",
    "C:\Projects\Config\Terminal",
    "C:\Projects\Config\Nginx",
    
    # Template directories
    "C:\Projects\Templates\WebApp",
    "C:\Projects\Templates\API",
    "C:\Projects\Templates\ReactApp",
    "C:\Projects\Templates\VueApp",
    "C:\Projects\Templates\AngularApp",
    "C:\Projects\Templates\NextApp",
    "C:\Projects\Templates\DotNetAPI",
    "C:\Projects\Templates\PythonAPI",
    "C:\Projects\Templates\ML",
    
    # Data directories
    "C:\Projects\Data\Raw",
    "C:\Projects\Data\Processed",
    "C:\Projects\Data\Models",
    "C:\Projects\Data\Results",
    
    # Documentation directories
    "C:\Projects\Documentation\Architecture",
    "C:\Projects\Documentation\APIs",
    "C:\Projects\Documentation\UserGuides",
    "C:\Projects\Documentation\DevGuides",
    
    # Special directories
    "C:\Projects\Local",
    "C:\Projects\Scratch",
    "C:\Projects\Backup"
)

# Create all project directories
foreach ($folder in $comprehensiveProjectFolders) {
    if (!(Test-Path -Path $folder)) {
        try {
            New-Item -Path $folder -ItemType Directory -Force
            Write-Host "Created directory: $folder" -ForegroundColor Green
        } catch {
            Write-Host "Error creating directory $folder : $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Directory already exists: $folder" -ForegroundColor Gray
    }
}

# 4. Check for Chocolatey installation and install if needed
Write-Host "Checking and installing Chocolatey package manager..." -ForegroundColor Cyan
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    try {
        Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Host "Chocolatey installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "Error installing Chocolatey: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Chocolatey is already installed" -ForegroundColor Green
}

# 5. Check for Winget installation
Write-Host "Checking Winget package manager..." -ForegroundColor Cyan
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget not found. Please install App Installer from the Microsoft Store." -ForegroundColor Yellow
    Write-Host "Once installed, run this script again." -ForegroundColor Yellow
    $installAppInstaller = Read-Host "Do you want to continue without Winget for now? (Y/N)"
    if ($installAppInstaller -ne "Y" -and $installAppInstaller -ne "y") {
        Write-Host "Exiting script. Please install App Installer and run this script again." -ForegroundColor Red
        exit
    }
}

# 6. Define the list of required tools
$requiredTools = @(
    @{Name = "git"; Command = "git"; PackageId = "Git.Git"; ChocoName = "git" },
    @{Name = "Visual Studio Code"; Command = "code"; PackageId = "Microsoft.VisualStudioCode"; ChocoName = "vscode" },
    @{Name = "Python 3.11"; Command = "python"; PackageId = "Python.Python.3.11"; ChocoName = "python311" },
    @{Name = "Node.js"; Command = "node"; PackageId = "OpenJS.NodeJS.LTS"; ChocoName = "nodejs-lts" },
    @{Name = "Docker Desktop"; Command = "docker"; PackageId = "Docker.DockerDesktop"; ChocoName = "docker-desktop" },
    @{Name = "PostgreSQL"; Command = "psql"; PackageId = "PostgreSQL.PostgreSQL"; ChocoName = "postgresql" },
    @{Name = "Azure CLI"; Command = "az"; PackageId = "Microsoft.AzureCLI"; ChocoName = "azure-cli" },
    @{Name = "PowerToys"; Command = $null; PackageId = "Microsoft.PowerToys"; ChocoName = "powertoys" },
    @{Name = "Postman"; Command = $null; PackageId = "Postman.Postman"; ChocoName = "postman" },
    @{Name = "Google Chrome"; Command = $null; PackageId = "Google.Chrome"; ChocoName = "googlechrome" },
    @{Name = "Notepad++"; Command = "notepad++"; PackageId = "Notepad++.Notepad++"; ChocoName = "notepadplusplus" },
    @{Name = "Windows Terminal"; Command = "wt"; PackageId = "Microsoft.WindowsTerminal"; ChocoName = "microsoft-windows-terminal" },
    @{Name = "Ngrok"; Command = "ngrok"; PackageId = "Ngrok.Ngrok"; ChocoName = "ngrok" },
    @{Name = "PowerShell 7"; Command = "pwsh"; PackageId = "Microsoft.PowerShell"; ChocoName = "powershell-core" },
    @{Name = "GitHub CLI"; Command = "gh"; PackageId = "GitHub.cli"; ChocoName = "gh" }
)

# 7. Check for installed tools and install missing ones
Write-Host "Checking for installed development tools..." -ForegroundColor Cyan

$missingTools = @()
foreach ($tool in $requiredTools) {
    $toolName = $tool.Name
    $toolCommand = $tool.Command
    
    if ($toolCommand -and (Get-Command $toolCommand -ErrorAction SilentlyContinue)) {
        Write-Host "$toolName is already installed" -ForegroundColor Green
    } else {
        Write-Host "$toolName is not installed or not in PATH" -ForegroundColor Yellow
        $missingTools += $tool
    }
}

# Ask for permission to install missing tools
if ($missingTools.Count -gt 0) {
    Write-Host "The following tools need to be installed:" -ForegroundColor Yellow
    foreach ($tool in $missingTools) {
        Write-Host "- $($tool.Name)" -ForegroundColor Yellow
    }
    
    $installMissing = Read-Host "Do you want to install missing tools? (Y/N)"
    if ($installMissing -eq "Y" -or $installMissing -eq "y") {
        # Try using winget first, fallback to chocolatey
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            foreach ($tool in $missingTools) {
                Write-Host "Installing $($tool.Name) using winget..." -ForegroundColor Yellow
                winget install $tool.PackageId --accept-package-agreements --accept-source-agreements
            }
        } else {
            foreach ($tool in $missingTools) {
                Write-Host "Installing $($tool.Name) using chocolatey..." -ForegroundColor Yellow
                choco install $tool.ChocoName -y
            }
        }
        
        # Refresh environment after installation
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    }
}

# 8. Install Node Version Manager (NVM) if Node.js is selected
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "Checking for Node Version Manager (NVM)..." -ForegroundColor Cyan
    if (!(Get-Command nvm -ErrorAction SilentlyContinue)) {
        $installNvm = Read-Host "NVM (Node Version Manager) is not installed. Do you want to install it? (Y/N)"
        if ($installNvm -eq "Y" -or $installNvm -eq "y") {
            Write-Host "Installing Node Version Manager (nvm)..." -ForegroundColor Yellow
            $nvmInstallerUrl = "https://github.com/coreybutler/nvm-windows/releases/download/1.1.11/nvm-setup.exe"
            $nvmInstallerPath = "$env:TEMP\nvm-setup.exe"

            try {
                Invoke-WebRequest -Uri $nvmInstallerUrl -OutFile $nvmInstallerPath
                Start-Process -FilePath $nvmInstallerPath -ArgumentList "/SILENT" -Wait
                Write-Host "NVM for Windows installation completed" -ForegroundColor Green
                
                # Refresh environment variables
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                
                # Install Node.js LTS
                Write-Host "Installing Node.js LTS using NVM..." -ForegroundColor Yellow
                nvm install lts
                nvm use lts
            } catch {
                Write-Host "Could not automatically install NVM: $_" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "NVM is already installed" -ForegroundColor Green
    }
    
    # Install global Node.js packages
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Host "Installing global Node.js packages..." -ForegroundColor Yellow
        npm install -g typescript ts-node nodemon prettier eslint webpack webpack-cli create-react-app @vue/cli next
    }
}

# 9. Install Python packages if Python is selected
if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "Installing Python packages..." -ForegroundColor Yellow
    python -m pip install --upgrade pip
    
    # Check if uv is installed
    if (!(Get-Command uv -ErrorAction SilentlyContinue)) {
        Write-Host "Installing uv package manager..." -ForegroundColor Yellow
        pip install uv
    }
    
    # Install essential Python packages
    Write-Host "Installing essential Python packages..." -ForegroundColor Yellow
    pip install black pytest pylint flake8 mypy
    
    # Optional Python packages
    $optionalPythonPackages = "django djangorestframework requests python-dotenv pandas numpy matplotlib jupyter"
    $installOptionalPython = Read-Host "Do you want to install optional Python packages ($optionalPythonPackages)? (Y/N)"
    
    if ($installOptionalPython -eq "Y" -or $installOptionalPython -eq "y") {
        Write-Host "Installing optional Python packages..." -ForegroundColor Yellow
        pip install $optionalPythonPackages.Split(" ")
    }
    
    # Create uv path directory if needed
    $uvPath = "$env:LOCALAPPDATA\uv\bin"
    if (!(Test-Path -Path $uvPath)) {
        New-Item -Path $uvPath -ItemType Directory -Force
    }
}

# 10. Fix environment PATH variables
Write-Host "Fixing environment PATH variables..." -ForegroundColor Cyan

# Get current PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$pathArray = $currentPath.Split(';') | Where-Object { $_ -ne "" }

# Add missing paths
foreach ($path in $script:PathDirectories) {
    # Create directory if it doesn't exist
    if (!(Test-Path -Path $path -ErrorAction SilentlyContinue)) {
        try {
            New-Item -Path $path -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
            Write-Host "Created directory for PATH: $path" -ForegroundColor Green
        } catch {
            Write-Host "Could not create directory: $path - $_" -ForegroundColor Yellow
        }
    }
    
    # Add to PATH if not already there
    if ($pathArray -notcontains $path) {
        $pathArray += $path
        Write-Host "Added to PATH: $path" -ForegroundColor Green
    }
}

# Clean up any duplicate paths and empty entries
$cleanPathArray = $pathArray | Where-Object { $_ -ne "" } | Select-Object -Unique
$cleanPath = $cleanPathArray -join ';'

# Set the updated PATH
[Environment]::SetEnvironmentVariable("PATH", $cleanPath, "User")
Write-Host "Updated User PATH environment variable" -ForegroundColor Green

# Refresh current session PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 11. Set environment variables
Write-Host "Setting environment variables..." -ForegroundColor Cyan
foreach ($key in $script:EnvironmentVariables.Keys) {
    [Environment]::SetEnvironmentVariable($key, $script:EnvironmentVariables[$key], "User")
    Write-Host "Set environment variable: $key = $($script:EnvironmentVariables[$key])" -ForegroundColor Green
}

# 12. Validate the installation
Write-Host "Validating installation..." -ForegroundColor Cyan

# Check directories
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
} else {
    Write-Host "✗ Main Projects directory does not exist" -ForegroundColor Red
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

# Check critical tools
Write-Host "`nChecking critical development tools:" -ForegroundColor Cyan
$criticalTools = @("git", "node", "python", "code", "docker", "az")
foreach ($tool in $criticalTools) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        $version = & $tool --version 2>&1
        Write-Host "✓ $tool is installed: $version" -ForegroundColor Green
    } else {
        Write-Host "✗ $tool is not installed or not in PATH" -ForegroundColor Red
    }
}

Write-Host "`nSetup and verification complete!" -ForegroundColor Cyan
Write-Host "Your development environment should now be properly configured."
Write-Host "Please restart your terminal or computer for all changes to take effect."