# Script to install VS Code extensions for development

Write-Host "Installing recommended VS Code extensions..." -ForegroundColor Cyan

$extensions = @(
    # General Development
    "ms-vscode.powershell",
    "ms-azuretools.vscode-docker",
    "ms-vscode-remote.remote-wsl",
    "ms-vscode-remote.remote-containers",
    "github.copilot",
    "github.vscode-pull-request-github",
    "eamodio.gitlens",
    "mhutchie.git-graph",
    "pkief.material-icon-theme",

    # Web Development
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ritwickdey.liveserver",
    "bradlc.vscode-tailwindcss",
    "formulahendry.auto-rename-tag",
    "ms-vscode.live-server",

    # Python Development
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-python.black-formatter",
    "njpwerner.autodocstring",

    # .NET Development
    "ms-dotnettools.csharp",
    "ms-dotnettools.vscode-dotnet-runtime",
    "ms-vscode.vscode-typescript-next",

    # Azure Tools
    "ms-vscode.azure-account",
    "ms-azuretools.vscode-azurefunctions",
    "ms-azuretools.vscode-bicep",
    "ms-vscode.vscode-node-azure-pack",

    # Utilities
    "streetsidesoftware.code-spell-checker",
    "yzhang.markdown-all-in-one",
    "redhat.vscode-yaml",
    "redhat.vscode-xml",
    "mikestead.dotenv",
    "christian-kohler.path-intellisense"
)

foreach ($extension in $extensions) {
    Write-Host "Installing: $extension" -ForegroundColor Yellow
    code --install-extension $extension
}

Write-Host "VS Code extensions installation complete!" -ForegroundColor Green