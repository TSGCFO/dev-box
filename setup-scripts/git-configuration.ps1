# Script to configure Git settings
# Place in C:\DevBoxSetup\setup-git.ps1

Write-Host "Setting up Git configuration..." -ForegroundColor Cyan

# Create Git config directory
$gitConfigDir = "C:\Projects\Config\Git"
if (!(Test-Path -Path $gitConfigDir)) {
    New-Item -Path $gitConfigDir -ItemType Directory -Force
}

# Prompt for Git user information
$gitName = Read-Host -Prompt "Enter your Git username"
$gitEmail = Read-Host -Prompt "Enter your Git email"

# Configure Git globally
git config --global user.name "$gitName"
git config --global user.email "$gitEmail"
git config --global init.defaultBranch main
git config --global core.autocrlf input
git config --global core.editor "code --wait"

# Set up Git aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Create global .gitignore file
$gitignoreContent = @"
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

# IDEs and editors
.idea/
.vscode/
*.swp
*.swo
*~
.project
.classpath
.settings/
"@

$gitignoreContent | Out-File -FilePath "$gitConfigDir\.gitignore_global" -Encoding utf8
git config --global core.excludesfile "$gitConfigDir\.gitignore_global"

Write-Host "Git configuration complete!" -ForegroundColor Green
