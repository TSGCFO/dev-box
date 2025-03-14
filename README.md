# Azure Dev Box Setup Catalog

This repository contains scripts and configuration files for setting up a standardized development environment on Azure Dev Box. The catalog provides a consistent, repeatable setup for developer workstations with common tools and configurations.

## What's Included

- **Developer Tools**: Git, VS Code, Node.js, Python, Docker, Azure CLI, and more
- **VS Code Extensions**: A curated set of extensions for various development scenarios
- **Git Configuration**: Standard Git settings, useful aliases, and global .gitignore
- **Environment Settings**: PowerShell profile, environment variables, and folder structure
- **Welcome Screen**: A helpful welcome screen with status information and shortcuts

## Folder Structure

- `setup-scripts/`: Contains all the PowerShell scripts for setting up the environment
- `vscode-extensions/`: Contains VS Code extension configuration
- `app-configs/`: Contains application-specific configurations
- `resources/`: Contains additional files and templates

## Main Scripts

1. **master-setup.ps1**: The main orchestration script that runs all other scripts
2. **install-tools.ps1**: Installs developer tools and applications
3. **git-configuration.ps1**: Sets up Git configuration
4. **vscode-configuration.ps1**: Configures VS Code with extensions and settings
5. **setup-environment.ps1**: Sets up environment variables and project structure

## How to Use

### Automatic Setup (Azure Dev Box Task)

The catalog is designed to work with Azure Dev Box tasks. When a new Dev Box is created, the setup scripts can be automatically run.

### Manual Setup

If you need to run the setup manually:

1. Clone this repository to your Dev Box
2. Navigate to the repository folder
3. Run the master setup script:

```powershell
.\setup-scripts\master-setup.ps1
```

### Individual Components

You can also run individual setup scripts if you only need specific components:

```powershell
# Install developer tools
.\setup-scripts\install-tools.ps1

# Configure Git
.\setup-scripts\git-configuration.ps1

# Configure VS Code
.\setup-scripts\vscode-configuration.ps1

# Set up environment
.\setup-scripts\setup-environment.ps1
```

## Customization

You can customize the setup by modifying the scripts before running them:

1. Edit the scripts to add or remove tools, extensions, or configurations
2. Update the `catalog.json` file to reflect your changes
3. Commit and push your changes to the repository

## Updates and Maintenance

To update an existing Dev Box with the latest configurations:

1. Pull the latest changes from the repository
2. Run the master setup script again:

```powershell
git pull
.\setup-scripts\master-setup.ps1
```

This will update your environment with any changes made to the scripts since your last setup.

## Troubleshooting

If you encounter issues during setup:

1. Check the console output for error messages
2. Each script can be run individually to isolate problems
3. Most scripts are idempotent and can be safely re-run

## Contributing

To contribute to this catalog:

1. Fork the repository
2. Make your changes
3. Submit a pull request

Please ensure that any changes you make are thoroughly tested on a fresh Dev Box.