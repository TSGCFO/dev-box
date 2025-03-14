# Python Configuration

## Recommended pyproject.toml (Poetry)

```toml
[tool.poetry]
name = "project-name"
version = "0.1.0"
description = "Project description"
authors = ["Your Name <your.email@example.com>"]
readme = "README.md"

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.95.1"
uvicorn = "^0.21.1"
sqlalchemy = "^2.0.9"
pydantic = "^1.10.7"
python-dotenv = "^1.0.0"
alembic = "^1.10.3"
httpx = "^0.24.0"
pytest = "^7.3.1"

[tool.poetry.group.dev.dependencies]
black = "^23.3.0"
isort = "^5.12.0"
mypy = "^1.2.0"
pytest = "^7.3.1"
pytest-cov = "^4.0.0"
pylint = "^2.17.2"
flake8 = "^6.0.0"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"

[tool.black]
line-length = 88
target-version = ["py311"]

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.11"
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
strict_optional = true
warn_redundant_casts = true
warn_return_any = true
warn_unused_ignores = true

[tool.pytest.ini_options]
testpaths = ["tests"]
```

## Recommended pip configuration (pip.ini)

```ini
[global]
timeout = 60
trusted-host = pypi.python.org
               pypi.org
               files.pythonhosted.org
```

## UV Package Manager Configuration

```toml
# .uv/settings.toml
[uv]
index-url = "https://pypi.org/simple"
```

## Pre-commit hooks (.pre-commit-config.yaml)

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files

-   repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
    -   id: black

-   repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
    -   id: isort

-   repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
    -   id: flake8
        additional_dependencies: [flake8-docstrings]

-   repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.2.0
    hooks:
    -   id: mypy
        additional_dependencies: [pydantic]
```

## Common Environment Setup

```bash
# Create a virtual environment with uv
uv venv .venv

# Activate the virtual environment
# Windows
.venv\Scripts\activate
# Linux/Mac
source .venv/bin/activate

# Install dependencies with uv
uv pip install -r requirements.txt
```