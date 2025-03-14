# Centralized configuration definitions for Azure Dev Box
# This file contains shared configuration data used across multiple setup scripts

# Common directory paths
$script:ProjectsRoot = "C:\Projects"
$script:ConfigRoot = "C:\Projects\Config"
$script:TemplatesRoot = "C:\Projects\Templates"

# Git configuration
function Get-GitIgnoreContent {
    return @"
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Node.js
node_modules/
npm-debug.log
yarn-error.log
package-lock.json
yarn.lock
.pnp/
.pnp.js
.npm/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg
.env
.venv
venv/
ENV/
.pytest_cache/
pytestdebug.log

# Java
*.class
*.log
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar
hs_err_pid*
.gradle/
.mvn/
target/

# .NET
bin/
obj/
.vs/
_ReSharper*/
*.resharper
*.suo
*.user
*.userosscache
*.sln.docstates
packages/

# IDEs and editors
.idea/
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.swp
*.swo
*~
.project
.classpath
.settings/
.history/

# Environment files
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Azure
.azure/
servicebus.json
appsettings.*.json
local.settings.json

# Misc
.cache/
.temp/
.tmp/
coverage/
.coverage
"@
}

# Docker configuration
function Get-DockerConfig {
    return @"
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "features": {
    "buildkit": true
  },
  "wsl-ubuntu": {
    "enabled": true
  }
}
"@
}

# Python pip configuration
function Get-PipConfig {
    return @"
[global]
trusted-host = pypi.python.org
               pypi.org
               files.pythonhosted.org
timeout = 60
"@
}

# Node.js npm configuration
function Get-NpmConfig {
    return @"
registry=https://registry.npmjs.org/
save=true
save-exact=false
init-author-name=
init-author-email=
init-license=MIT
"@
}

# Environment variables that should be set
$script:EnvironmentVariables = @{
    "NODE_ENV" = "development"
    "PYTHONPATH" = "C:\Projects"
    "EDITOR" = "code"
    "PROJECTS_ROOT" = "C:\Projects"
}

# PATH directories that should be added
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

# Function to check tool installation status
function Test-ToolInstallation {
    param (
        [string]$CommandName,
        [string]$Arguments = "--version"
    )
    
    try {
        if (Get-Command $CommandName -ErrorAction SilentlyContinue) {
            $version = & $CommandName $Arguments.Split(" ") 2>&1
            return @{
                Installed = $true
                Version = $version
            }
        }
        else {
            return @{
                Installed = $false
                Version = $null
            }
        }
    }
    catch {
        return @{
            Installed = $false
            Version = $null
        }
    }
}

# Function to check Ngrok authentication status
function Test-NgrokAuth {
    try {
        if (Get-Command ngrok -ErrorAction SilentlyContinue) {
            $ngrokConfig = ngrok config check 2>&1
            if ($ngrokConfig -notmatch "error") {
                return @{
                    Configured = $true
                    Message = "Configured"
                }
            } else {
                return @{
                    Configured = $false
                    Message = "Not configured"
                }
            }
        } else {
            return @{
                Configured = $false
                Message = "Ngrok not installed"
            }
        }
    } catch {
        return @{
            Configured = $false
            Message = "Error checking Ngrok configuration"
        }
    }
}