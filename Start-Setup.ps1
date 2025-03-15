# Quick setup script to initialize development environment

Write-Host "Starting dev box setup..." -ForegroundColor Cyan

# Create Projects directory structure
$projectBaseDirs = @(
    "C:\Projects",
    "C:\Projects\WebApps",
    "C:\Projects\APIs",
    "C:\Projects\Scripts",
    "C:\Projects\Libraries",
    "C:\Projects\Templates",
    "C:\Projects\Config",
    "C:\Projects\Data"
)

foreach ($dir in $projectBaseDirs) {
    if (!(Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force
        Write-Host "Created directory: $dir" -ForegroundColor Green
    }
}

# Create basic template directories
$templateDirs = @(
    "C:\Projects\Templates\WebApp",
    "C:\Projects\Templates\API",
    "C:\Projects\Templates\ReactApp"
)

foreach ($dir in $templateDirs) {
    if (!(Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force
        Write-Host "Created template directory: $dir" -ForegroundColor Green
    }
}

# Set up environment variables
$envVars = @{
    "NODE_ENV" = "development"
    "PYTHONPATH" = "C:\Projects"
    "EDITOR" = "code"
    "PROJECTS_ROOT" = "C:\Projects"
}

foreach ($key in $envVars.Keys) {
    [Environment]::SetEnvironmentVariable($key, $envVars[$key], "User")
    Write-Host "Set environment variable: $key = $($envVars[$key])" -ForegroundColor Green
}

# Create package.json in API template directory
$packageJsonContent = @"
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

$apiTemplatePath = "C:\Projects\Templates\API\package.json"
$packageJsonContent | Out-File -FilePath $apiTemplatePath -Force -Encoding utf8

Write-Host "Created package.json template at: $apiTemplatePath" -ForegroundColor Green

# Create a simple index.js for the API template
$indexJsContent = @"
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.json({ message: 'API is running' });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Sample API endpoint
app.get('/api/items', (req, res) => {
  res.json([
    { id: 1, name: 'Item 1' },
    { id: 2, name: 'Item 2' },
    { id: 3, name: 'Item 3' }
  ]);
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
"@

$apiIndexPath = "C:\Projects\Templates\API\src"
if (!(Test-Path -Path $apiIndexPath)) {
    New-Item -Path $apiIndexPath -ItemType Directory -Force
}
$indexJsContent | Out-File -FilePath "$apiIndexPath\index.js" -Force -Encoding utf8

Write-Host "Created API template index.js at: $apiIndexPath\index.js" -ForegroundColor Green

# Create a React template
$reactIndexContent = @"
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
"@

$reactAppContent = @"
import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>React Template</h1>
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
      </header>
    </div>
  );
}

export default App;
"@

$reactAppCssContent = @"
.App {
  text-align: center;
}

.App-header {
  background-color: #282c34;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
  color: white;
}
"@

$reactSrcPath = "C:\Projects\Templates\ReactApp\src"
if (!(Test-Path -Path $reactSrcPath)) {
    New-Item -Path $reactSrcPath -ItemType Directory -Force
}

$reactIndexContent | Out-File -FilePath "$reactSrcPath\index.js" -Force -Encoding utf8
$reactAppContent | Out-File -FilePath "$reactSrcPath\App.js" -Force -Encoding utf8
$reactAppCssContent | Out-File -FilePath "$reactSrcPath\App.css" -Force -Encoding utf8

Write-Host "Created React template files in: $reactSrcPath" -ForegroundColor Green

# Create a README for the Projects directory
$projectsReadme = @"
# Development Projects

This directory contains all development projects organized by category.

## Directory Structure

- **WebApps/** - Web applications and sites
- **APIs/** - API services and backends
- **Scripts/** - Utility scripts and automation
- **Libraries/** - Reusable code libraries and packages
- **Templates/** - Project templates and starters
- **Config/** - Configuration files for various tools
- **Data/** - Data files and datasets

## Best Practices

1. Organize projects in the appropriate category folder
2. Use consistent naming conventions
3. Include a README.md in each project
4. Keep the folder structure clean and organized
"@

$projectsReadme | Out-File -FilePath "C:\Projects\README.md" -Force -Encoding utf8

Write-Host "Created README.md at: C:\Projects\README.md" -ForegroundColor Green

Write-Host "Dev box quick setup complete!" -ForegroundColor Green
Write-Host "You can now use the C:\Projects directory for your development work." -ForegroundColor Cyan