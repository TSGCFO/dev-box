# Dev Box Setup UI
# Interactive setup wizard for Dev Box configuration

# Script requires administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as Administrator" -ForegroundColor Red
    exit
}

# Import core configuration
. "$PSScriptRoot\config-definitions.ps1"

# ==========================================
# UI Helper Functions
# ==========================================

function Show-Header {
    param(
        [string]$Title
    )
    
    Clear-Host
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-ProgressBar {
    param(
        [int]$StepNumber,
        [int]$TotalSteps
    )
    
    $percentComplete = [math]::Round(($StepNumber / $TotalSteps) * 100)
    
    Write-Host "Progress: [$StepNumber/$TotalSteps] $percentComplete%" -ForegroundColor Yellow
    
    $progressBar = ""
    $barWidth = 50
    $filledWidth = [math]::Round(($percentComplete / 100) * $barWidth)
    
    for ($i = 0; $i -lt $barWidth; $i++) {
        if ($i -lt $filledWidth) {
            $progressBar += "▓"
        } else {
            $progressBar += "░"
        }
    }
    
    Write-Host $progressBar -ForegroundColor Yellow
    Write-Host ""
}

function Get-UserInput {
    param(
        [string]$Prompt,
        [string]$Default = "",
        [switch]$Required,
        [switch]$IsSecure
    )
    
    $promptText = "$Prompt"
    if ($Default -ne "") {
        $promptText += " [Default: $Default]"
    }
    $promptText += ": "
    
    do {
        if ($IsSecure) {
            $secureString = Read-Host -Prompt $promptText -AsSecureString
            if ($secureString.Length -eq 0 -and $Default -ne "") {
                return $Default
            }
            elseif ($secureString.Length -eq 0 -and $Required) {
                Write-Host "This field is required." -ForegroundColor Red
                $inputValid = $false
            }
            else {
                $inputValid = $true
                # Convert secure string to plain text for processing
                $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
                $plainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
                return $plainText
            }
        }
        else {
            $input = Read-Host -Prompt $promptText
            if ($input -eq "" -and $Default -ne "") {
                return $Default
            }
            elseif ($input -eq "" -and $Required) {
                Write-Host "This field is required." -ForegroundColor Red
                $inputValid = $false
            }
            else {
                $inputValid = $true
                return $input
            }
        }
    } while (-not $inputValid)
}

function Get-MultipleChoiceSelection {
    param(
        [string]$Prompt,
        [hashtable[]]$Options,
        [string[]]$DefaultSelections = @(),
        [switch]$Multiple
    )
    
    Write-Host "$Prompt" -ForegroundColor Yellow
    Write-Host "------------------------------------------------" -ForegroundColor Gray
    
    for ($i = 0; $i -lt $Options.Count; $i++) {
        $option = $Options[$i]
        $isSelected = $DefaultSelections -contains $option.Id
        $selectionMark = if ($isSelected) { "[X]" } else { "[ ]" }
        
        if ($option.Required) {
            Write-Host "$($i+1). $selectionMark $($option.Name) (Required)" -ForegroundColor Green
        } else {
            Write-Host "$($i+1). $selectionMark $($option.Name)" -ForegroundColor White
        }
        
        if ($option.Description) {
            Write-Host "   $($option.Description)" -ForegroundColor Gray
        }
    }
    
    Write-Host "------------------------------------------------" -ForegroundColor Gray
    if ($Multiple) {
        Write-Host "Enter the numbers of your selections (comma-separated, e.g. 1,3,5)" -ForegroundColor Yellow
    } else {
        Write-Host "Enter the number of your selection" -ForegroundColor Yellow
    }
    Write-Host "Press Enter to accept defaults" -ForegroundColor Yellow
    
    $input = Read-Host -Prompt "Selection"
    
    if ([string]::IsNullOrWhiteSpace($input)) {
        # Return default selections
        return $DefaultSelections
    }
    
    $selectedIds = @()
    
    if ($Multiple) {
        $selectedIndices = $input.Split(',') | ForEach-Object { $_.Trim() }
        foreach ($index in $selectedIndices) {
            if ([int]::TryParse($index, [ref]$null)) {
                $arrayIndex = [int]$index - 1
                if ($arrayIndex -ge 0 -and $arrayIndex -lt $Options.Count) {
                    $selectedIds += $Options[$arrayIndex].Id
                }
            }
        }
    } else {
        if ([int]::TryParse($input, [ref]$null)) {
            $arrayIndex = [int]$input - 1
            if ($arrayIndex -ge 0 -and $arrayIndex -lt $Options.Count) {
                $selectedIds += $Options[$arrayIndex].Id
            }
        }
    }
    
    # Add required options
    foreach ($option in $Options) {
        if ($option.Required -and $selectedIds -notcontains $option.Id) {
            $selectedIds += $option.Id
        }
    }
    
    return $selectedIds
}

function Show-Summary {
    param(
        [hashtable]$Config
    )
    
    Show-Header "Installation Summary"
    
    Write-Host "User Information:" -ForegroundColor Yellow
    Write-Host "- Git Username: $($Config.UserInfo.GitUsername)"
    Write-Host "- Git Email: $($Config.UserInfo.GitEmail)"
    Write-Host ""
    
    Write-Host "Selected Components:" -ForegroundColor Yellow
    foreach ($component in $Config.Components) {
        Write-Host "- $component"
    }
    Write-Host ""
    
    Write-Host "Configuration Options:" -ForegroundColor Yellow
    $Config.Options.GetEnumerator() | ForEach-Object {
        Write-Host "- $($_.Key): $($_.Value)"
    }
    Write-Host ""
    
    Write-Host "Credentials:" -ForegroundColor Yellow
    Write-Host "- Git Username: [Set]"
    Write-Host "- Git Email: [Set]"
    
    if ($Config.Credentials.ContainsKey("NgrokToken") -and $Config.Credentials.NgrokToken -ne "") {
        Write-Host "- Ngrok Token: [Set]"
    }
    
    if ($Config.Credentials.ContainsKey("AzureDevOpsOrg") -and $Config.Credentials.AzureDevOpsOrg -ne "") {
        Write-Host "- Azure DevOps Org: [Set]"
    }
    
    Write-Host ""
    Write-Host "Do you want to proceed with the installation?" -ForegroundColor Green
    $confirmation = Read-Host "Enter [Y]es to continue, [N]o to cancel"
    
    return $confirmation -eq "Y" -or $confirmation -eq "y" -or $confirmation -eq "Yes" -or $confirmation -eq "yes"
}

# ==========================================
# Setup Wizard Steps
# ==========================================

function Show-Introduction {
    Show-Header "Dev Box Setup Wizard"
    
    Write-Host "Welcome to the Dev Box Setup Wizard!" -ForegroundColor Green
    Write-Host ""
    Write-Host "This wizard will guide you through configuring your development environment."
    Write-Host "You will be able to customize:"
    Write-Host "  - User information for Git and other services"
    Write-Host "  - Development tools to install"
    Write-Host "  - WSL distributions and configurations"
    Write-Host "  - Project templates and settings"
    Write-Host ""
    Write-Host "Estimated setup time: 15-30 minutes depending on selections and internet speed."
    Write-Host ""
    
    Read-Host "Press Enter to continue"
    return $true
}

function Get-UserInformation {
    param(
        [hashtable]$Config
    )
    
    Show-Header "User Information"
    Show-ProgressBar -StepNumber 1 -TotalSteps 7
    
    $Config.UserInfo = @{}
    
    $Config.UserInfo.GitUsername = Get-UserInput -Prompt "Git username" -Default $env:USERNAME -Required
    $Config.UserInfo.GitEmail = Get-UserInput -Prompt "Git email" -Default "$($env:USERNAME)@example.com" -Required
    $Config.UserInfo.ProjectsDirectory = Get-UserInput -Prompt "Projects directory" -Default "C:\Dev\Projects"
    
    Write-Host ""
    Write-Host "User information collected successfully!" -ForegroundColor Green
    Start-Sleep -Seconds 1
    
    return $Config
}

function Select-InstallationOptions {
    param(
        [hashtable]$Config
    )
    
    Show-Header "Installation Options"
    Show-ProgressBar -StepNumber 2 -TotalSteps 7
    
    $Config.Options = @{}
    
    # Create WSL options
    $wslOptions = @(
        @{ Id = "wsl-ubuntu"; Name = "Ubuntu"; Description = "Ubuntu Linux distribution"; Required = $false },
        @{ Id = "wsl-opensuse"; Name = "openSUSE"; Description = "openSUSE Linux distribution"; Required = $false }
    )
    
    $Config.Options.WSLDistributions = Get-MultipleChoiceSelection -Prompt "Which WSL distributions would you like to install?" -Options $wslOptions -DefaultSelections @("wsl-ubuntu") -Multiple
    
    # Configure project structure
    $projectStructureOptions = @(
        @{ Id = "simple"; Name = "Simple"; Description = "Basic project structure with minimal folders"; Required = $false },
        @{ Id = "comprehensive"; Name = "Comprehensive"; Description = "Full project structure with templates for multiple project types"; Required = $false }
    )
    
    $Config.Options.ProjectStructure = Get-MultipleChoiceSelection -Prompt "Which project structure would you like to set up?" -Options $projectStructureOptions -DefaultSelections @("comprehensive")
    
    # VS Code configuration
    $vsCodeConfigOptions = @(
        @{ Id = "default"; Name = "Default"; Description = "Standard VS Code configuration"; Required = $false },
        @{ Id = "custom"; Name = "Custom"; Description = "Customized VS Code configuration with specific settings"; Required = $false }
    )
    
    $Config.Options.VSCodeConfig = Get-MultipleChoiceSelection -Prompt "Which VS Code configuration would you like to use?" -Options $vsCodeConfigOptions -DefaultSelections @("default")
    
    Write-Host ""
    Write-Host "Installation options selected successfully!" -ForegroundColor Green
    Start-Sleep -Seconds 1
    
    return $Config
}

function Select-DevTools {
    param(
        [hashtable]$Config
    )
    
    Show-Header "Development Tools"
    Show-ProgressBar -StepNumber 3 -TotalSteps 7
    
    $Config.Components = @()
    
    # Required components
    $requiredComponents = @(
        @{ Id = "git"; Name = "Git"; Description = "Version control system"; Required = $true },
        @{ Id = "vscode"; Name = "Visual Studio Code"; Description = "Code editor"; Required = $true },
        @{ Id = "python3.11"; Name = "Python 3.11"; Description = "Python programming language"; Required = $true }
    )
    
    # Optional development tools
    $devToolOptions = @(
        @{ Id = "node"; Name = "Node.js"; Description = "JavaScript runtime"; Required = $false },
        @{ Id = "docker"; Name = "Docker Desktop"; Description = "Container platform"; Required = $false },
        @{ Id = "postgresql"; Name = "PostgreSQL"; Description = "SQL database"; Required = $false },
        @{ Id = "github-cli"; Name = "GitHub CLI"; Description = "Command-line tool for GitHub"; Required = $false },
        @{ Id = "ngrok"; Name = "ngrok"; Description = "Local tunneling service"; Required = $false }
    )
    
    # Add required components
    foreach ($component in $requiredComponents) {
        $Config.Components += $component.Id
    }
    
    # Select optional components
    $selectedDevTools = Get-MultipleChoiceSelection -Prompt "Which development tools would you like to install?" -Options $devToolOptions -DefaultSelections @("node", "docker") -Multiple
    
    $Config.Components += $selectedDevTools
    
    # If Node.js is selected, prompt for versions
    if ($selectedDevTools -contains "node") {
        $nodeVersionOptions = @(
            @{ Id = "18.19.0"; Name = "Node.js 18.19.0 LTS"; Description = "Maintenance LTS version"; Required = $false },
            @{ Id = "20.10.0"; Name = "Node.js 20.10.0 LTS"; Description = "Active LTS version"; Required = $false },
            @{ Id = "21.6.1"; Name = "Node.js 21.6.1"; Description = "Current version"; Required = $false }
        )
        
        $Config.Options.NodeVersions = Get-MultipleChoiceSelection -Prompt "Which Node.js versions would you like to install?" -Options $nodeVersionOptions -DefaultSelections @("20.10.0") -Multiple
    }
    
    # AI tool options
    $aiToolOptions = @(
        @{ Id = "claudecode"; Name = "Claude Code"; Description = "Anthropic's Claude Code CLI"; Required = $false },
        @{ Id = "claude"; Name = "Claude Desktop"; Description = "Claude desktop application"; Required = $false },
        @{ Id = "chatgpt"; Name = "ChatGPT Desktop"; Description = "ChatGPT desktop application"; Required = $false }
    )
    
    $selectedAITools = Get-MultipleChoiceSelection -Prompt "Which AI tools would you like to install?" -Options $aiToolOptions -DefaultSelections @() -Multiple
    
    $Config.Components += $selectedAITools
    
    Write-Host ""
    Write-Host "Development tools selected successfully!" -ForegroundColor Green
    Start-Sleep -Seconds 1
    
    return $Config
}

function Collect-Credentials {
    param(
        [hashtable]$Config
    )
    
    Show-Header "Credentials"
    Show-ProgressBar -StepNumber 4 -TotalSteps 7
    
    $Config.Credentials = @{}
    
    # Git credentials (already collected in user info, but stored here for consistency)
    $Config.Credentials.GitUsername = $Config.UserInfo.GitUsername
    $Config.Credentials.GitEmail = $Config.UserInfo.GitEmail
    
    # Conditional credential collection
    if ($Config.Components -contains "ngrok") {
        Write-Host "ngrok authentication token is required for ngrok functionality." -ForegroundColor Yellow
        $Config.Credentials.NgrokToken = Get-UserInput -Prompt "ngrok auth token" -IsSecure
    }
    
    # Ask about Azure DevOps
    $configureAzureDevOps = Get-UserInput -Prompt "Do you want to configure Azure DevOps? (Y/N)" -Default "N"
    if ($configureAzureDevOps -eq "Y" -or $configureAzureDevOps -eq "y") {
        $Config.Credentials.AzureDevOpsOrg = Get-UserInput -Prompt "Azure DevOps organization"
    }
    
    # API keys
    $configureAPIKeys = Get-UserInput -Prompt "Do you want to configure API keys for AI services? (Y/N)" -Default "N"
    if ($configureAPIKeys -eq "Y" -or $configureAPIKeys -eq "y") {
        if ($Config.Components -contains "claudecode" -or $Config.Components -contains "claude") {
            $Config.Credentials.AnthropicAPIKey = Get-UserInput -Prompt "Anthropic API key" -IsSecure
        }
        
        if ($Config.Components -contains "chatgpt") {
            $Config.Credentials.OpenAIAPIKey = Get-UserInput -Prompt "OpenAI API key" -IsSecure
        }
    }
    
    Write-Host ""
    Write-Host "Credentials collected successfully!" -ForegroundColor Green
    Start-Sleep -Seconds 1
    
    return $Config
}

function Configure-Environment {
    param(
        [hashtable]$Config
    )
    
    Show-Header "Environment Configuration"
    Show-ProgressBar -StepNumber 5 -TotalSteps 7
    
    # Update config-definitions.ps1 with user choices
    Write-Host "Updating configuration definitions..." -ForegroundColor Yellow
    
    # This will be implemented to modify the config-definitions.ps1 file based on user selections
    # For now, we're just simulating the behavior
    
    Write-Host "Preparing installation scripts..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    
    # Set the export path
    $tempConfigPath = Join-Path $env:TEMP "dev-box-config.json"
    
    Write-Host "Configuration will be exported to: $tempConfigPath" -ForegroundColor Gray
    
    # Convert config to JSON and save
    $configJson = $Config | ConvertTo-Json -Depth 5
    $configJson | Out-File -FilePath $tempConfigPath -Encoding utf8
    
    Write-Host ""
    Write-Host "Environment configuration completed successfully!" -ForegroundColor Green
    Start-Sleep -Seconds 1
    
    return $Config
}

function Run-Installation {
    param(
        [hashtable]$Config,
        [string]$ConfigPath
    )
    
    Show-Header "Installation"
    Show-ProgressBar -StepNumber 6 -TotalSteps 7
    
    Write-Host "Starting installation process..." -ForegroundColor Yellow
    Write-Host "This may take some time depending on your selections." -ForegroundColor Yellow
    Write-Host ""
    
    # Set environment variables based on config
    $env:GIT_USERNAME = $Config.Credentials.GitUsername
    $env:GIT_EMAIL = $Config.Credentials.GitEmail
    
    if ($Config.Credentials.ContainsKey("NgrokToken") -and $Config.Credentials.NgrokToken -ne "") {
        $env:NGROK_AUTH_TOKEN = $Config.Credentials.NgrokToken
    }
    
    if ($Config.Credentials.ContainsKey("AnthropicAPIKey") -and $Config.Credentials.AnthropicAPIKey -ne "") {
        $env:ANTHROPIC_API_KEY = $Config.Credentials.AnthropicAPIKey
    }
    
    if ($Config.Credentials.ContainsKey("OpenAIAPIKey") -and $Config.Credentials.OpenAIAPIKey -ne "") {
        $env:OPENAI_API_KEY = $Config.Credentials.OpenAIAPIKey
    }
    
    # Export component selections for master-setup.ps1
    $env:SELECTED_COMPONENTS = $Config.Components -join ","
    $env:USER_OPTIONS = ($Config.Options | ConvertTo-Json -Compress)
    
    Write-Host "Running master setup script..." -ForegroundColor Yellow
    
    try {
        # Run master setup script with the configuration
        & "$PSScriptRoot\master-setup.ps1"
        
        $installationSuccess = $true
    }
    catch {
        Write-Host "Error during installation: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor Red
        
        $installationSuccess = $false
    }
    
    # Clean up environment variables
    Remove-Item Env:\GIT_USERNAME -ErrorAction SilentlyContinue
    Remove-Item Env:\GIT_EMAIL -ErrorAction SilentlyContinue
    Remove-Item Env:\NGROK_AUTH_TOKEN -ErrorAction SilentlyContinue
    Remove-Item Env:\ANTHROPIC_API_KEY -ErrorAction SilentlyContinue
    Remove-Item Env:\OPENAI_API_KEY -ErrorAction SilentlyContinue
    Remove-Item Env:\SELECTED_COMPONENTS -ErrorAction SilentlyContinue
    Remove-Item Env:\USER_OPTIONS -ErrorAction SilentlyContinue
    
    if ($installationSuccess) {
        Write-Host ""
        Write-Host "Installation completed successfully!" -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "Installation completed with errors. Please check the logs for details." -ForegroundColor Red
    }
    
    Start-Sleep -Seconds 1
    
    return $installationSuccess
}

function Show-Completion {
    param(
        [bool]$Success
    )
    
    Show-Header "Setup Complete"
    Show-ProgressBar -StepNumber 7 -TotalSteps 7
    
    if ($Success) {
        Write-Host "Congratulations! Your Dev Box has been successfully set up." -ForegroundColor Green
        Write-Host ""
        Write-Host "Your development environment is now ready to use." -ForegroundColor Green
        Write-Host "You may need to restart your computer to ensure all changes take effect."
    }
    else {
        Write-Host "Setup completed with some errors." -ForegroundColor Yellow
        Write-Host "Please review the logs and address any issues manually."
        Write-Host "You can run the setup again to retry failed components."
    }
    
    Write-Host ""
    Write-Host "Thank you for using Dev Box Setup!" -ForegroundColor Cyan
    
    Read-Host "Press Enter to exit"
}

# ==========================================
# Main Setup Flow
# ==========================================

function Start-DevBoxSetupWizard {
    # Initialize configuration
    $config = @{}
    
    # Show introduction
    $continue = Show-Introduction
    if (-not $continue) { return }
    
    # Collect user information
    $config = Get-UserInformation -Config $config
    
    # Select installation options
    $config = Select-InstallationOptions -Config $config
    
    # Select development tools
    $config = Select-DevTools -Config $config
    
    # Collect credentials
    $config = Collect-Credentials -Config $config
    
    # Configure environment
    $config = Configure-Environment -Config $config
    
    # Show summary and confirm
    $proceed = Show-Summary -Config $config
    
    if ($proceed) {
        # Export config to temp file
        $tempConfigPath = Join-Path $env:TEMP "dev-box-config.json"
        $config | ConvertTo-Json -Depth 5 | Out-File -FilePath $tempConfigPath -Encoding utf8
        
        # Run installation
        $success = Run-Installation -Config $config -ConfigPath $tempConfigPath
        
        # Clean up temp config file
        if (Test-Path $tempConfigPath) {
            Remove-Item -Path $tempConfigPath -Force
        }
        
        # Show completion
        Show-Completion -Success $success
    }
    else {
        Write-Host "Setup cancelled by user." -ForegroundColor Yellow
    }
}

# Start the wizard
Start-DevBoxSetupWizard