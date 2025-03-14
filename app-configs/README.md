# Application Configurations

This directory contains configuration files for various applications and development tools in the Dev Box environment.

## Available Configurations

- **docker/**: Docker and Docker Compose configurations
- **git/**: Git configuration files
- **node/**: Node.js and npm configuration
- **python/**: Python and pip configuration
- **terminal/**: Terminal profiles and settings
- **nginx/**: Nginx server configurations
- **postgres/**: PostgreSQL database configurations
- **wsl/**: WSL distribution configurations

## How to Use

These configuration files are automatically copied to their appropriate locations when running the setup scripts. You can also manually copy them to your desired locations.

### Docker

The Docker configuration includes:
- Sample docker-compose files for different scenarios
- Dockerfile templates for various applications
- Docker networking configurations

### Git

The Git configuration includes:
- Global .gitignore file
- Git aliases for common commands
- Git commit templates
- Git hook templates

### Node.js

The Node.js configuration includes:
- .npmrc configuration
- package.json templates
- tsconfig.json templates
- eslint and prettier configurations

### Python

The Python configuration includes:
- pip.conf configuration
- pyproject.toml templates
- requirements.txt templates
- pytest configuration

### WSL

The WSL configuration includes:
- wslconfig settings
- Linux distribution configurations
- Integration settings

## Customization

To customize these configurations:

1. Edit the configuration files as needed
2. Run the appropriate setup script to apply changes
3. Or manually copy the files to their target locations

## Adding New Configurations

To add new configuration files:

1. Create a new directory for the tool/application if it doesn't exist
2. Add your configuration files
3. Update the README.md to document the new configurations
4. If needed, modify the setup scripts to copy these files to the appropriate locations