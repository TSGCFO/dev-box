# CLAUDE.md - Dev Box Environment Guide

## Development Commands
- **Python Testing**: `pytest` or `pytest path/to/test.py -v` for specific tests
- **Python Linting**: `black .` (formatting), `pylint file.py`, `flake8`, `mypy`
- **Node.js/TypeScript**: `npm run lint`, `npm test`, `npm run build`
- **Format JS/TS**: `prettier --write "**/*.{js,jsx,ts,tsx}"`

## Code Style Guidelines
- **Python**: Follow PEP 8, use Black formatter, type hints with mypy
- **JavaScript/TypeScript**: Use Prettier, ESLint with standard config
- **Naming**: camelCase for JS/TS, snake_case for Python
- **Imports**: Group standard library, third-party, and local imports
- **Error Handling**: Use try/except with specific exceptions in Python
- **Documentation**: Docstrings for Python, JSDoc for JS/TS functions

## Environment Setup
- Use NVM for Node.js version management (`nvm use 20.10.0`)
- Use UV package manager for Python (`uv install package`)
- Default Python version: 3.11
- WSL distributions available: Ubuntu and openSUSE

## Repository Structure
- `setup-scripts/`: PowerShell scripts for environment setup
- `vscode-extensions/`: VS Code extension configuration
- `app-configs/`: Application-specific configurations
- `resources/`: Additional files and templates