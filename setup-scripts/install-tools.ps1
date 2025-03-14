# Script to install development tools for Azure Dev Box
param (
    [string[]]$Components = @()
)

# Load central configuration
. $PSScriptRoot\config-definitions.ps1

Write-Host "Installing development tools for Azure Dev Box..." -ForegroundColor Cyan

# Default required components if none specified
if ($Components.Count -eq 0) {
    $Components = @(
        "git", "vscode", "python3.11", "node", "docker", "postgresql", 
        "azure-cli", "powertoys", "postman", "chrome", "notepadplusplus", 
        "windowsterminal", "ngrok", "github-cli", "powershell",
        "claudecode", "claude", "chatgpt"
    )
    Write-Host "No components specified, installing all default tools" -ForegroundColor Yellow
}
else {
    Write-Host "Installing specified components: $($Components -join ', ')" -ForegroundColor Yellow
    
    # Always ensure core tools are included
    if ($Components -notcontains "git") { $Components += "git" }
    if ($Components -notcontains "vscode") { $Components += "vscode" }
    if ($Components -notcontains "python3.11") { $Components += "python3.11" }
    if ($Components -notcontains "powershell") { $Components += "powershell" }
    if ($Components -notcontains "windowsterminal") { $Components += "windowsterminal" }
}

# Install Chocolatey if not already installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh environment variables to get choco command
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Map component IDs to Winget package identifiers
$toolsMapping = @{
    "git" = "Git.Git"
    "vscode" = "Microsoft.VisualStudioCode"
    "python3.11" = "Python.Python.3.11"
    "node" = "OpenJS.NodeJS.LTS"
    "docker" = "Docker.DockerDesktop"
    "postgresql" = "PostgreSQL.PostgreSQL"
    "azure-cli" = "Microsoft.AzureCLI"
    "powertoys" = "Microsoft.PowerToys"
    "postman" = "Postman.Postman"
    "chrome" = "Google.Chrome"
    "notepadplusplus" = "Notepad++.Notepad++"
    "windowsterminal" = "Microsoft.WindowsTerminal"
    "ngrok" = "Ngrok.Ngrok"
    "powershell" = "Microsoft.PowerShell"
    "claudecode" = "Anthropic.ClaudeCode"
    "claude" = "Anthropic.Claude"
    "chatgpt" = "OpenAI.ChatGPT"
}

# Create Winget config file based on selected components
$wingetPackages = @()
foreach ($component in $Components) {
    if ($toolsMapping.ContainsKey($component)) {
        $wingetPackages += @{ "PackageIdentifier" = $toolsMapping[$component] }
    }
}

$wingetConfig = @{
    '$$schema' = "https://aka.ms/winget-packages.schema.2.0.json"
    'CreationDate' = (Get-Date -Format "yyyy-MM-dd")
    'Sources' = @(
        @{
            'SourceDetails' = @{
                'Name' = "winget"
                'Identifier' = "Microsoft.Winget.Source_8wekyb3d8bbwe"
                'Argument' = ""
                'Type' = "Microsoft.PreIndexed.Package"
            }
            'Packages' = $wingetPackages
        }
    )
}

# Convert the config to JSON
$wingetConfigJson = $wingetConfig | ConvertTo-Json -Depth 5

$wingetConfigPath = "$PSScriptRoot\devbox-tools.json"
$wingetConfigJson | Out-File -FilePath $wingetConfigPath -Encoding utf8

# Install tools using Winget as primary package manager
if ($wingetPackages.Count -gt 0) {
    Write-Host "Installing applications using Winget..." -ForegroundColor Yellow
    winget import -i $wingetConfigPath --accept-package-agreements --accept-source-agreements --ignore-unavailable
}
else {
    Write-Host "No packages selected for Winget installation" -ForegroundColor Yellow
}

# Chocolatey will only be used for tools not available in Winget
# Determine which tools were not successfully installed by Winget but were requested
$fallbackTools = @()

# Check for tools that might not have been installed by Winget
$toolsToCheck = @{
    "ngrok" = "ngrok"
    "postgresql" = "psql"
}

foreach ($tool in $toolsToCheck.Keys) {
    if ($Components -contains $tool -and !(Get-Command $toolsToCheck[$tool] -ErrorAction SilentlyContinue)) {
        $fallbackTools += $tool
    }
}

if ($fallbackTools.Count -gt 0) {
    Write-Host "Installing missing tools using Chocolatey..." -ForegroundColor Yellow
    foreach ($tool in $fallbackTools) {
        Write-Host "Installing $tool with Chocolatey..." -ForegroundColor Yellow
        choco install $tool -y
    }
}

# Install Claude if selected
if ($Components -contains "claude") {
    Write-Host "Installing Claude Desktop..." -ForegroundColor Yellow
    $claudeInstallerUrl = "https://cdn.anthropic.com/claude-desktop/windows/stable/ClaudeDesktopSetup.exe"
    $claudeInstallerPath = "$env:TEMP\ClaudeDesktopSetup.exe"

    try {
        Invoke-WebRequest -Uri $claudeInstallerUrl -OutFile $claudeInstallerPath
        Start-Process -FilePath $claudeInstallerPath -ArgumentList "/S" -Wait
        Write-Host "Claude Desktop installation completed" -ForegroundColor Green
    } catch {
        Write-Host "Could not automatically install Claude Desktop. Please install manually." -ForegroundColor Yellow
    }
}

# Install Node Version Manager (nvm) for Windows if Node.js is selected
if ($Components -contains "node") {
    Write-Host "Installing Node Version Manager (nvm)..." -ForegroundColor Yellow
    $nvmInstallerUrl = "https://github.com/coreybutler/nvm-windows/releases/download/1.1.11/nvm-setup.exe"
    $nvmInstallerPath = "$env:TEMP\nvm-setup.exe"

    try {
        Invoke-WebRequest -Uri $nvmInstallerUrl -OutFile $nvmInstallerPath
        Start-Process -FilePath $nvmInstallerPath -ArgumentList "/SILENT" -Wait
        Write-Host "NVM for Windows installation completed" -ForegroundColor Green
        
        # Refresh environment variables to get nvm command
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        # Get Node.js versions from options or use defaults
        $nodeVersions = @("20.10.0")  # Default version
        
        if ($env:USER_OPTIONS) {
            try {
                $userOptions = $env:USER_OPTIONS | ConvertFrom-Json
                if ($userOptions.NodeVersions) {
                    $nodeVersions = $userOptions.NodeVersions
                }
            } catch {
                Write-Host "Error parsing Node.js versions from options, using default" -ForegroundColor Yellow
            }
        }
        
        # Install specified Node.js versions
        foreach ($version in $nodeVersions) {
            Write-Host "Installing Node.js $version..." -ForegroundColor Yellow
            nvm install $version
        }
        
        # Use the last version as default
        nvm use $nodeVersions[-1]
    } catch {
        Write-Host "Could not automatically install NVM. Please install manually." -ForegroundColor Yellow
    }
    
    # Install Node.js packages globally if node is selected
    Write-Host "Installing Node.js packages..." -ForegroundColor Yellow
    npm install -g typescript ts-node nodemon prettier eslint webpack webpack-cli create-react-app @vue/cli next
}

# Install Python packages if Python is selected
if ($Components -contains "python3.11") {
    Write-Host "Installing Python packages and uv..." -ForegroundColor Yellow
    pip install --upgrade pip
    pip install uv
    pip install black pytest pylint flake8 mypy
    
    # Optional Python packages
    $optionalPythonPackages = "django djangorestframework requests python-dotenv pandas numpy matplotlib jupyter"
    
    # Ask user if they want to install optional packages or use default from environment
    $installOptionalPython = $true
    if (-not $env:INSTALL_OPTIONAL_PYTHON_PACKAGES) {
        $response = Read-Host "Do you want to install optional Python packages ($optionalPythonPackages)? (Y/N)"
        $installOptionalPython = $response -eq "Y" -or $response -eq "y"
    }
    elseif ($env:INSTALL_OPTIONAL_PYTHON_PACKAGES -eq "false") {
        $installOptionalPython = $false
    }
    
    if ($installOptionalPython) {
        Write-Host "Installing optional Python packages..." -ForegroundColor Yellow
        pip install $optionalPythonPackages.Split(" ")
    }
    
    # Create uv path directory if needed, but PATH management is centralized in setup-environment.ps1
    $uvPath = "$env:LOCALAPPDATA\uv\bin"
    if (!(Test-Path -Path $uvPath)) {
        New-Item -Path $uvPath -ItemType Directory -Force
    }
}

# Install WSL and Linux distributions if selected in options
if ($userOptions -and $userOptions.WSLDistributions) {
    $wslDistributions = $userOptions.WSLDistributions
    
    if ($wslDistributions.Count -gt 0) {
        Write-Host "Installing WSL base components..." -ForegroundColor Yellow
        wsl --install --no-distribution
        
        # Enable Hyper-V and Virtual Machine Platform if needed for WSL
        Write-Host "Enabling Hyper-V and Virtual Machine Platform..." -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
        
        if ($wslDistributions -contains "wsl-ubuntu") {
            Write-Host "Installing Ubuntu WSL distribution..." -ForegroundColor Yellow
            wsl --install -d Ubuntu
        }
        
        if ($wslDistributions -contains "wsl-opensuse") {
            Write-Host "Installing openSUSE WSL distribution..." -ForegroundColor Yellow
            wsl --install -d openSUSE-Leap-15.5
        }
    }
}
else {
    # Default behavior if no specific WSL options provided
    Write-Host "Installing WSL and Linux distributions..." -ForegroundColor Yellow
    wsl --install --no-distribution
    
    Write-Host "Installing Ubuntu WSL distribution (default)..." -ForegroundColor Yellow
    wsl --install -d Ubuntu
}

# Install Azure PowerShell modules if Azure CLI is selected
if ($Components -contains "azure-cli") {
    Write-Host "Installing Azure PowerShell modules..." -ForegroundColor Yellow
    if (!(Get-Module -ListAvailable -Name Az)) {
        Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
    }
}

# Install GitHub CLI if selected
if ($Components -contains "github-cli") {
    Write-Host "Installing GitHub CLI..." -ForegroundColor Yellow
    winget install GitHub.cli --accept-source-agreements --accept-package-agreements
}

# Configure ngrok with auth token if selected and provided
if ($Components -contains "ngrok") {
    Write-Host "Configuring ngrok..." -ForegroundColor Yellow
    
    # Check if ngrok is installed using the centralized function
    $ngrokStatus = Test-ToolInstallation -CommandName "ngrok"
    if (!$ngrokStatus.Installed) {
        Write-Host "ngrok not found in PATH. Please install ngrok and configure it manually." -ForegroundColor Yellow
    } else {
        # Check if ngrok is already authenticated
        $ngrokAuthStatus = Test-NgrokAuth
        if ($ngrokAuthStatus.Configured) {
            Write-Host "ngrok is already configured with auth token" -ForegroundColor Green
        } else {
            $ngrokAuthToken = $env:NGROK_AUTH_TOKEN
            
            if ([string]::IsNullOrEmpty($ngrokAuthToken)) {
                $ngrokAuthToken = Read-Host -Prompt "Enter your ngrok auth token (press Enter to skip)"
            }
            
            if (![string]::IsNullOrEmpty($ngrokAuthToken)) {
                # Configure ngrok with the auth token
                Start-Process -FilePath "ngrok" -ArgumentList "config add-authtoken $ngrokAuthToken" -NoNewWindow -Wait
                Write-Host "ngrok configured with auth token" -ForegroundColor Green
            } else {
                Write-Host "No ngrok auth token provided. You'll need to configure ngrok manually." -ForegroundColor Yellow
            }
        }
    }
}

Write-Host "Development tools installation complete!" -ForegroundColor Green