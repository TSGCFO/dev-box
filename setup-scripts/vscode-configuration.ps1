# Script to configure VS Code for Azure Dev Box

Write-Host "Setting up VS Code configuration..." -ForegroundColor Cyan

# Check if VS Code is installed
if (!(Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "VS Code is not installed. Installing VS Code..." -ForegroundColor Yellow
    winget install Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements
    # Refresh environment variables to get code command
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Create VS Code config directory
$vsCodeConfigDir = "C:\Projects\Config\VSCode"
if (!(Test-Path -Path $vsCodeConfigDir)) {
    New-Item -Path $vsCodeConfigDir -ItemType Directory -Force
}

# Create VS Code settings.json with enhanced settings for development
$vsCodeSettings = @"
{
    "editor.formatOnSave": true,
    "editor.tabSize": 4,
    "editor.renderWhitespace": "all",
    "editor.bracketPairColorization.enabled": true,
    "editor.guides.bracketPairs": true,
    "editor.suggestSelection": "first",
    "editor.linkedEditing": true,
    "editor.wordWrap": "off",
    "editor.semanticHighlighting.enabled": true,
    "editor.minimap.enabled": true,
    "editor.inlineSuggest.enabled": true,
    
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    "files.exclude": {
        "**/.git": true,
        "**/.svn": true,
        "**/.hg": true,
        "**/CVS": true,
        "**/.DS_Store": true,
        "**/Thumbs.db": true,
        "**/__pycache__": true,
        "**/.pytest_cache": true,
        "**/*.pyc": true,
        "**/node_modules": true
    },
    
    "workbench.colorTheme": "Default Dark Modern",
    "workbench.iconTheme": "material-icon-theme",
    "workbench.editor.enablePreview": false,
    "workbench.startupEditor": "newUntitledFile",
    
    "terminal.integrated.defaultProfile.windows": "PowerShell",
    "terminal.integrated.profiles.windows": {
        "PowerShell": {
            "source": "PowerShell",
            "icon": "terminal-powershell"
        },
        "Command Prompt": {
            "path": [
                "\${env:windir}\\Sysnative\\cmd.exe",
                "\${env:windir}\\System32\\cmd.exe"
            ],
            "args": [],
            "icon": "terminal-cmd"
        },
        "Git Bash": {
            "source": "Git Bash"
        }
    },
    
    // Python settings
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "python.linting.flake8Enabled": true,
    "python.formatting.provider": "black",
    "python.analysis.typeCheckingMode": "basic",
    "python.terminal.activateEnvironment": true,
    "python.defaultInterpreterPath": "python",
    
    // JavaScript/TypeScript settings
    "javascript.updateImportsOnFileMove.enabled": "always",
    "typescript.updateImportsOnFileMove.enabled": "always",
    "javascript.format.enable": true,
    "typescript.format.enable": true,
    "javascript.suggest.completeFunctionCalls": true,
    "typescript.suggest.completeFunctionCalls": true,
    
    // Git settings
    "git.autofetch": true,
    "git.confirmSync": false,
    "git.enableSmartCommit": true,
    "git.suggestSmartCommit": true,
    "git.openRepositoryInParentFolders": "always",
    
    // Azure settings
    "azure.resourceFilter": [],
    "azureFunctions.showProjectWarning": false,
    
    // GitHub Copilot
    "github.copilot.enable": {
        "*": true,
        "yaml": true,
        "plaintext": true,
        "markdown": true
    },
    
    // Remote Development
    "remote.SSH.remotePlatform": {
        "azure-vm": "linux"
    },
    
    // Docker
    "docker.showStartPage": false,
    
    // Live Share
    "liveshare.guestApprovalRequired": true,
    
    // Telemetry
    "telemetry.telemetryLevel": "error"
}
"@

$vsCodeSettings | Out-File -FilePath "$vsCodeConfigDir\settings.json" -Encoding utf8

# Create a comprehensive list of VS Code extensions for development
Write-Host "Installing VS Code extensions..." -ForegroundColor Yellow

$extensions = @(
    # Essential
    "ms-vscode.powershell",                  # PowerShell
    "ms-python.python",                      # Python
    "ms-python.vscode-pylance",              # Python IntelliSense
    "ms-azuretools.vscode-docker",           # Docker
    "ms-vscode-remote.remote-wsl",           # WSL
    "ms-vscode-remote.remote-containers",    # Remote Containers
    "ms-vscode.azure-account",               # Azure Account
    "ms-azuretools.vscode-azurefunctions",   # Azure Functions
    "github.copilot",                        # GitHub Copilot
    "github.vscode-pull-request-github",     # GitHub Pull Requests
    "github.github-vscode-theme",            # GitHub Theme
    
    # Languages & Frameworks
    "dbaeumer.vscode-eslint",                # ESLint
    "esbenp.prettier-vscode",                # Prettier
    "ms-dotnettools.csharp",                 # C#
    "vscjava.vscode-java-pack",              # Java
    "redhat.vscode-yaml",                    # YAML
    "vscode-icons-team.vscode-icons",        # Icons
    "pkief.material-icon-theme",             # Material Icon Theme
    
    # Git
    "mhutchie.git-graph",                    # Git Graph
    "eamodio.gitlens",                       # GitLens
    
    # Tools
    "ms-vscode.live-server",                 # Live Server
    "ms-vsliveshare.vsliveshare",            # Live Share
    "ritwickdey.liveserver",                 # Live Server
    "streetsidesoftware.code-spell-checker", # Code Spell Checker
    "redhat.vscode-xml",                     # XML
    "ms-vscode.vscode-typescript-next",      # TypeScript Nightly
    "bradlc.vscode-tailwindcss",             # Tailwind CSS
    "ms-playwright.playwright",              # Playwright
    "ms-azuretools.vscode-bicep"             # Bicep
)

# Install extensions in parallel for better performance
$jobs = @()
$throttleLimit = 5  # Number of concurrent installations

foreach ($extension in $extensions) {
    Write-Host "Scheduling installation of VS Code extension: $extension" -ForegroundColor Yellow
    $jobs += Start-Job -ScriptBlock {
        param($ext)
        code --install-extension $ext --force
    } -ArgumentList $extension
    
    # Wait if we've reached the throttle limit
    while (($jobs | Where-Object { $_.State -eq 'Running' }).Count -ge $throttleLimit) {
        Start-Sleep -Seconds 1
        $jobs | Where-Object { $_.State -eq 'Completed' } | Receive-Job -AutoRemoveJob
    }
}

# Wait for all extension installations to complete
$jobs | Wait-Job | Receive-Job
$jobs | Remove-Job -Force -ErrorAction SilentlyContinue

# Copy settings to VS Code user directory
$vsCodeUserDir = "$env:APPDATA\Code\User"
if (!(Test-Path -Path $vsCodeUserDir)) {
    New-Item -Path $vsCodeUserDir -ItemType Directory -Force
}

Copy-Item -Path "$vsCodeConfigDir\settings.json" -Destination "$vsCodeUserDir\settings.json" -Force

# Create keybindings.json with useful keyboard shortcuts
$keybindings = @"
[
    {
        "key": "ctrl+shift+b",
        "command": "workbench.action.tasks.build"
    },
    {
        "key": "f5",
        "command": "workbench.action.debug.start"
    },
    {
        "key": "ctrl+shift+t",
        "command": "workbench.action.terminal.new"
    },
    {
        "key": "ctrl+k ctrl+s",
        "command": "workbench.action.files.saveAll"
    },
    {
        "key": "ctrl+k ctrl+f",
        "command": "editor.action.formatDocument"
    }
]
"@

$keybindings | Out-File -FilePath "$vsCodeUserDir\keybindings.json" -Force

Write-Host "VS Code configuration complete!" -ForegroundColor Green