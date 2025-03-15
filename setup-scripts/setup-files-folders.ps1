# Script to set up standard files and folders for development on Azure Dev Box
param (
    [string[]]$ProjectStructure = @("comprehensive")
)

Write-Host "Setting up standard files and folders for development..." -ForegroundColor Cyan
Write-Host "Project structure type: $ProjectStructure" -ForegroundColor Yellow

# Define the base project directory
$projectsBaseDir = "C:\Projects"

# Create the base projects directory
if (!(Test-Path -Path $projectsBaseDir)) {
    New-Item -Path $projectsBaseDir -ItemType Directory -Force
    Write-Host "Created base folder: $projectsBaseDir" -ForegroundColor Green
}

# Define project folder structures based on selection
$simpleProjectFolders = @(
    # Main project directories - Simple structure
    "$projectsBaseDir",
    "$projectsBaseDir\WebApps",
    "$projectsBaseDir\APIs",
    "$projectsBaseDir\Scripts",
    "$projectsBaseDir\Libraries",
    "$projectsBaseDir\Templates",
    "$projectsBaseDir\Data",
    "$projectsBaseDir\Config",
    
    # Template directories - Simple structure
    "$projectsBaseDir\Templates\WebApp",
    "$projectsBaseDir\Templates\API",
    
    # Special directories - Simple structure
    "$projectsBaseDir\Local",
    "$projectsBaseDir\Backup"
)

$comprehensiveProjectFolders = @(
    # Main project directories - Comprehensive structure
    "$projectsBaseDir",
    "$projectsBaseDir\WebApps",
    "$projectsBaseDir\APIs",
    "$projectsBaseDir\Mobile",
    "$projectsBaseDir\Desktop",
    "$projectsBaseDir\Scripts",
    "$projectsBaseDir\Libraries",
    "$projectsBaseDir\Tools",
    "$projectsBaseDir\ML",
    "$projectsBaseDir\AI",
    "$projectsBaseDir\Cloud",
    "$projectsBaseDir\DevOps",
    "$projectsBaseDir\Documentation",
    "$projectsBaseDir\Config",
    "$projectsBaseDir\Templates",
    "$projectsBaseDir\Research",
    "$projectsBaseDir\Data",
    
    # Configuration directories - Comprehensive structure
    "$projectsBaseDir\Config\VSCode",
    "$projectsBaseDir\Config\Git",
    "$projectsBaseDir\Config\NodeJS",
    "$projectsBaseDir\Config\Python",
    "$projectsBaseDir\Config\Azure",
    "$projectsBaseDir\Config\Docker",
    "$projectsBaseDir\Config\PowerShell",
    "$projectsBaseDir\Config\WSL",
    "$projectsBaseDir\Config\Terminal",
    "$projectsBaseDir\Config\Nginx",
    
    # Template directories - Comprehensive structure
    "$projectsBaseDir\Templates\WebApp",
    "$projectsBaseDir\Templates\API",
    "$projectsBaseDir\Templates\ReactApp",
    "$projectsBaseDir\Templates\VueApp",
    "$projectsBaseDir\Templates\AngularApp",
    "$projectsBaseDir\Templates\NextApp",
    "$projectsBaseDir\Templates\DotNetAPI",
    "$projectsBaseDir\Templates\PythonAPI",
    "$projectsBaseDir\Templates\ML",
    
    # Data directories - Comprehensive structure
    "$projectsBaseDir\Data\Raw",
    "$projectsBaseDir\Data\Processed",
    "$projectsBaseDir\Data\Models",
    "$projectsBaseDir\Data\Results",
    
    # Documentation directories - Comprehensive structure
    "$projectsBaseDir\Documentation\Architecture",
    "$projectsBaseDir\Documentation\APIs",
    "$projectsBaseDir\Documentation\UserGuides",
    "$projectsBaseDir\Documentation\DevGuides",
    
    # Special directories - Comprehensive structure
    "$projectsBaseDir\Local",
    "$projectsBaseDir\Scratch",
    "$projectsBaseDir\Backup"
)

# Determine which folders to create based on selected project structure
$projectFolders = $simpleProjectFolders  # Default to simple structure

if ($ProjectStructure -contains "comprehensive") {
    $projectFolders = $comprehensiveProjectFolders
    Write-Host "Creating comprehensive project structure..." -ForegroundColor Yellow
}
elseif ($ProjectStructure -contains "simple") {
    $projectFolders = $simpleProjectFolders
    Write-Host "Creating simple project structure..." -ForegroundColor Yellow
}

foreach ($folder in $projectFolders) {
    if (!(Test-Path -Path $folder)) {
        New-Item -Path $folder -ItemType Directory -Force
        Write-Host "Created folder: $folder" -ForegroundColor Green
    }
}

# Create template files

# React application template
$reactTemplate = @"
# React Application Template

## Getting Started

1. Clone this template
2. Run \`npm install\`
3. Run \`npm start\`

## Available Scripts

- \`npm start\` - Start the development server
- \`npm build\` - Build for production
- \`npm test\` - Run tests
- \`npm lint\` - Lint the code

## Project Structure

```
src/
  components/     # Reusable components
  pages/          # Page components
  hooks/          # Custom hooks
  context/        # React context
  services/       # API services
  utils/          # Utility functions
  assets/         # Static assets
  styles/         # CSS/SCSS files
  App.js          # Main application component
  index.js        # Entry point
```

## Best Practices

- Use functional components with hooks
- Implement proper error handling
- Write tests for all components
- Use TypeScript for type safety
"@

$reactTemplate | Out-File -FilePath "C:\Projects\Templates\ReactApp\README.md" -Force -Encoding utf8

# API template
$apiTemplate = @"
# API Template

## Getting Started

1. Clone this template
2. Install dependencies
3. Configure environment variables
4. Start the server

## Project Structure

```
src/
  controllers/    # Request handlers
  models/         # Data models
  routes/         # API routes
  services/       # Business logic
  middleware/     # Custom middleware
  utils/          # Utility functions
  config/         # Configuration
  app.js          # Application setup
  server.js       # Server entry point
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /api/v1/items | Get all items |
| GET    | /api/v1/items/:id | Get item by ID |
| POST   | /api/v1/items | Create new item |
| PUT    | /api/v1/items/:id | Update item |
| DELETE | /api/v1/items/:id | Delete item |

## Environment Variables

- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Environment (development, production)
- `DATABASE_URL` - Database connection string
- `JWT_SECRET` - Secret for JWT tokens
"@

$apiTemplate | Out-File -FilePath "C:\Projects\Templates\API\README.md" -Force -Encoding utf8

# Python API template
$pythonApiTemplate = @"
# Python API Template

## Getting Started

1. Clone this template
2. Create virtual environment: \`python -m venv venv\`
3. Activate environment: \`venv\\Scripts\\activate\`
4. Install dependencies: \`pip install -r requirements.txt\`
5. Run the application: \`python app.py\`

## Project Structure

```
app/
  __init__.py      # Initialize app
  routes/          # API routes
  models/          # Data models
  schemas/         # Pydantic schemas
  services/        # Business logic
  utils/           # Utility functions
  config.py        # Configuration
requirements.txt   # Dependencies
app.py             # Entry point
```

## Environment Variables

- `FLASK_APP` - Flask application entry point
- `FLASK_ENV` - Environment (development, production)
- `DATABASE_URL` - Database connection string
- `SECRET_KEY` - Application secret key
"@

$pythonApiTemplate | Out-File -FilePath "C:\Projects\Templates\PythonAPI\README.md" -Force -Encoding utf8

# Create a .gitignore template for the local directory
$gitignoreTemplate = @"
# Local development environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE files
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
.idea/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Dependencies
node_modules/
.pnp/
.pnp.js
package-lock.json
yarn.lock

# Python
__pycache__/
*.py[cod]
*$py.class
.Python
venv/
.venv/
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

# Testing
coverage/
.coverage
htmlcov/
.tox/
.pytest_cache/

# Production
/build
/dist

# Misc
.DS_Store
Thumbs.db
"@

$gitignoreTemplate | Out-File -FilePath "C:\Projects\Local\.gitignore" -Force -Encoding utf8
$gitignoreTemplate | Out-File -FilePath "C:\Projects\Scratch\.gitignore" -Force -Encoding utf8

# Create a README for the Projects directory
$projectsReadme = @"
# Development Projects

This directory contains all development projects organized by category.

## Directory Structure

- **WebApps/** - Web applications and sites
- **APIs/** - API services and backends
- **Mobile/** - Mobile application projects
- **Desktop/** - Desktop application projects
- **Scripts/** - Utility scripts and automation
- **Libraries/** - Reusable code libraries and packages
- **Tools/** - Development tools
- **ML/** - Machine learning projects
- **AI/** - AI and related projects
- **Cloud/** - Cloud infrastructure projects
- **DevOps/** - DevOps and CI/CD projects
- **Documentation/** - Project and technical documentation
- **Config/** - Configuration files for various tools
- **Templates/** - Project templates and starters
- **Research/** - Experimental and research projects
- **Data/** - Data files and datasets
- **Local/** - Local-only development (not version controlled)
- **Scratch/** - Quick experiments (not version controlled)
- **Backup/** - Backup files

## Best Practices

1. Organize projects in the appropriate category folder
2. Use consistent naming conventions
3. Include a README.md in each project
4. Keep the folder structure clean and organized
5. Archive old projects instead of deleting them
"@

$projectsReadme | Out-File -FilePath "C:\Projects\README.md" -Force -Encoding utf8

# Create sample .env files
$envTemplate = @"
# Environment Variables
# Copy this file to .env and modify as needed

# API Configuration
API_URL=http://localhost:3000
API_KEY=your_api_key_here

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=devdb
DB_USER=developer
DB_PASSWORD=password

# Auth Configuration
JWT_SECRET=your_jwt_secret_here
JWT_EXPIRES_IN=1d

# App Configuration
PORT=3000
NODE_ENV=development
DEBUG=true
"@

$envTemplate | Out-File -FilePath "C:\Projects\Templates\API\.env.example" -Force -Encoding utf8
$envTemplate | Out-File -FilePath "C:\Projects\Templates\WebApp\.env.example" -Force -Encoding utf8

# Get Node.js config from app-configs instead of duplicating
$repoRoot = Split-Path -Parent $PSScriptRoot
$nodeConfigDir = Join-Path -Path $repoRoot -ChildPath "app-configs"
$nodeConfigFile = Join-Path -Path $nodeConfigDir -ChildPath "nodejs-config.md"

# Check if nodejs-config.md exists and contains package.json template
$foundPackageJson = $false
if (Test-Path -Path $nodeConfigFile) {
    $nodeConfigContent = Get-Content -Path $nodeConfigFile -Raw
    if ($nodeConfigContent -match "(?s)```package.json(.*?)```") {
        $packageJsonTemplate = $matches[1].Trim()
        $foundPackageJson = $true
    }
}

# If we didn't find package.json in nodejs-config.md, use a default template
if (-not $foundPackageJson) {
    $packageJsonTemplate = @"
{
  "name": "app-name",
  "version": "1.0.0",
  "description": "Description of your application",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "lint": "eslint ."
  },
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.0.3",
    "cors": "^2.8.5",
    "helmet": "^6.0.1",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.22",
    "jest": "^29.5.0",
    "eslint": "^8.38.0"
  },
  "engines": {
    "node": ">=14.0.0"
  },
  "author": "Your Name",
  "license": "MIT"
}
"@
}

$packageJsonTemplate | Out-File -FilePath "C:\Projects\Templates\API\package.json" -Force -Encoding utf8

# Get Python config from app-configs instead of duplicating
$repoRoot = Split-Path -Parent $PSScriptRoot
$pythonConfigDir = Join-Path -Path $repoRoot -ChildPath "app-configs"
$pythonConfigFile = Join-Path -Path $pythonConfigDir -ChildPath "python-config.md"

# Check if python-config.md exists and contains requirements
$foundRequirements = $false
if (Test-Path -Path $pythonConfigFile) {
    $pythonConfigContent = Get-Content -Path $pythonConfigFile -Raw
    if ($pythonConfigContent -match "(?s)```requirements.txt(.*?)```") {
        $requirementsTemplate = $matches[1].Trim()
        $foundRequirements = $true
    }
}

# If we didn't find requirements in python-config.md, use a default template
if (-not $foundRequirements) {
    $requirementsTemplate = @"
# Web frameworks
flask==2.2.3
fastapi==0.95.1
django==4.2.0

# API and HTTP
requests==2.28.2
httpx==0.24.0
aiohttp==3.8.4

# Database
sqlalchemy==2.0.9
psycopg2-binary==2.9.6
pymongo==4.3.3

# Auth and security
pyjwt==2.6.0
passlib==1.7.4
python-jose==3.3.0

# Data processing
pandas==2.0.0
numpy==1.24.2
scipy==1.10.1

# Testing
pytest==7.3.1
pytest-cov==4.0.0

# Utilities
python-dotenv==1.0.0
pydantic==1.10.7
"@
}

$requirementsTemplate | Out-File -FilePath "C:\Projects\Templates\PythonAPI\requirements.txt" -Force -Encoding utf8

# Use app-configs/docker template files instead of duplicating here
# Source the centralized configuration
. $PSScriptRoot\config-definitions.ps1

# Get paths to Docker template files in app-configs
$repoRoot = Split-Path -Parent $PSScriptRoot
$dockerConfigDir = Join-Path -Path $repoRoot -ChildPath "app-configs\docker"

# Copy Docker Compose file if it exists
$dockerComposeSource = Join-Path -Path $dockerConfigDir -ChildPath "docker-compose.yml"
if (Test-Path -Path $dockerComposeSource) {
    Copy-Item -Path $dockerComposeSource -Destination "C:\Projects\Templates\API\docker-compose.yml" -Force
} else {
    Write-Host "Docker Compose template not found at $dockerComposeSource" -ForegroundColor Yellow
}

# Copy Node.js Dockerfile if it exists
$nodeDockerfileSource = Join-Path -Path $dockerConfigDir -ChildPath "node-api.Dockerfile"
if (Test-Path -Path $nodeDockerfileSource) {
    Copy-Item -Path $nodeDockerfileSource -Destination "C:\Projects\Templates\API\Dockerfile" -Force
} else {
    Write-Host "Node.js Dockerfile template not found at $nodeDockerfileSource" -ForegroundColor Yellow
}

# Copy Frontend Dockerfile if it exists
$frontendDockerfileSource = Join-Path -Path $dockerConfigDir -ChildPath "frontend.Dockerfile"
if (Test-Path -Path $frontendDockerfileSource) {
    Copy-Item -Path $frontendDockerfileSource -Destination "C:\Projects\Templates\WebApp\Dockerfile" -Force
    Copy-Item -Path $frontendDockerfileSource -Destination "C:\Projects\Templates\ReactApp\Dockerfile" -Force
} else {
    Write-Host "Frontend Dockerfile template not found at $frontendDockerfileSource" -ForegroundColor Yellow
}

# Create a basic Python Dockerfile if needed - no duplication as this is unique to setup-files-folders.ps1
$pythonDockerfileTemplate = @"
# Python API Dockerfile
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Expose port
EXPOSE 5000

# Start the application
CMD ["python", "app.py"]
"@

$pythonDockerfileTemplate | Out-File -FilePath "C:\Projects\Templates\PythonAPI\Dockerfile" -Force -Encoding utf8

# Create a basic Azure DevOps pipeline template
$azurePipelineTemplate = @"
# Azure DevOps Pipeline Template

trigger:
  branches:
    include:
      - main
      - develop
  paths:
    exclude:
      - README.md
      - docs/**

pool:
  vmImage: 'ubuntu-latest'

variables:
  isMain: `$[eq(variables['Build.SourceBranch'], 'refs/heads/main')]

stages:
  - stage: Build
    displayName: 'Build and Test'
    jobs:
      - job: BuildAndTest
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: '18.x'
            displayName: 'Install Node.js'

          - script: |
              npm ci
            displayName: 'Install dependencies'

          - script: |
              npm run lint
            displayName: 'Run linting'

          - script: |
              npm test
            displayName: 'Run tests'

          - script: |
              npm run build
            displayName: 'Build application'

          - task: PublishBuildArtifacts@1
            inputs:
              pathtoPublish: 'build'
              artifactName: 'drop'
            displayName: 'Publish artifacts'

  - stage: Deploy
    displayName: 'Deploy'
    dependsOn: Build
    condition: and(succeeded(), eq(variables.isMain, true))
    jobs:
      - job: DeployToProduction
        steps:
          - task: DownloadBuildArtifacts@0
            inputs:
              buildType: 'current'
              downloadType: 'single'
              artifactName: 'drop'
              downloadPath: '`$(System.ArtifactsDirectory)'

          - task: AzureWebApp@1
            inputs:
              azureSubscription: '`$(AZURE_SUBSCRIPTION)'
              appType: 'webApp'
              appName: '`$(APP_NAME)'
              package: '`$(System.ArtifactsDirectory)/drop'
              deploymentMethod: 'auto'
"@

$azurePipelineTemplate | Out-File -FilePath "C:\Projects\Templates\API\azure-pipelines.yml" -Force -Encoding utf8

# Create a GitHub Actions workflow template
$githubWorkflowTemplate = @"
# GitHub Actions Workflow Template

name: Build and Deploy

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run linting
      run: npm run lint

    - name: Run tests
      run: npm test

    - name: Build application
      run: npm run build

    - name: Upload build artifacts
      uses: actions/upload-artifact@v3
      with:
        name: build-files
        path: build/

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest

    steps:
    - name: Download build artifacts
      uses: actions/download-artifact@v3
      with:
        name: build-files
        path: build

    - name: Deploy to Azure Web App
      uses: azure/webapps-deploy@v2
      with:
        app-name: `${{ secrets.AZURE_WEBAPP_NAME }}
        publish-profile: `${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}
        package: build
"@

$githubWorkflowTemplate | Out-File -FilePath "C:\Projects\Templates\API\.github\workflows\main.yml" -Force -Encoding utf8

# Ensure directory exists for the GitHub workflow
if (!(Test-Path -Path "C:\Projects\Templates\API\.github\workflows")) {
    New-Item -Path "C:\Projects\Templates\API\.github\workflows" -ItemType Directory -Force
}

# Create a basic TypeScript config
$tsconfigTemplate = @"
{
  "compilerOptions": {
    "target": "es2020",
    "module": "commonjs",
    "lib": ["es2020"],
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "moduleResolution": "node",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "**/*.spec.ts"]
}
"@

$tsconfigTemplate | Out-File -FilePath "C:\Projects\Templates\API\tsconfig.json" -Force -Encoding utf8

# Copy VSCode settings from central location to templates
# Source the centralized config
. $PSScriptRoot\config-definitions.ps1

# Get path to centralized VS Code settings
$repoRoot = Split-Path -Parent $PSScriptRoot
$vsCodeExtDir = Join-Path -Path $repoRoot -ChildPath "vscode-extensions"
$settingsPath = Join-Path -Path $vsCodeExtDir -ChildPath "settings.json"

# Ensure directory exists for VSCode settings
foreach ($templateDir in @("API", "ReactApp", "PythonAPI", "WebApp")) {
    $vscodeDirPath = "C:\Projects\Templates\$templateDir\.vscode"
    if (!(Test-Path -Path $vscodeDirPath)) {
        New-Item -Path $vscodeDirPath -ItemType Directory -Force
    }
    Copy-Item -Path $settingsPath -Destination "$vscodeDirPath\settings.json" -Force
}

Write-Host "Standard files and folders setup complete!" -ForegroundColor Green