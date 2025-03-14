# WSL (Windows Subsystem for Linux) Cheat Sheet

## Installation and Setup

```powershell
# List available distributions
wsl --list --online

# Install a specific distribution
wsl --install -d Ubuntu

# Set default WSL version to 2
wsl --set-default-version 2

# Convert a distribution to WSL 2
wsl --set-version Ubuntu 2

# Set default distribution
wsl --set-default Ubuntu
```

## Basic Operations

```powershell
# Start a specific distribution
wsl -d Ubuntu

# Run a command in WSL
wsl echo "Hello from WSL"

# Run a specific command in a specific distribution
wsl -d Ubuntu -e ls -la

# Terminate a running distribution
wsl --terminate Ubuntu

# Shutdown all WSL instances
wsl --shutdown
```

## File System Navigation

```bash
# Access Windows files from WSL
cd /mnt/c/Users/YourUsername/Documents

# Access WSL files from Windows Explorer
# In File Explorer address bar: \\wsl$\Ubuntu
```

## Distribution Management

```powershell
# Export a distribution to a tar file
wsl --export Ubuntu C:\path\to\ubuntu.tar

# Import a distribution from a tar file
wsl --import CustomUbuntu C:\path\to\CustomUbuntu C:\path\to\ubuntu.tar

# Unregister (delete) a distribution
wsl --unregister Ubuntu
```

## Configuration

```powershell
# Edit WSL configuration
notepad "$env:USERPROFILE\.wslconfig"
```

Example .wslconfig:
```
[wsl2]
memory=4GB
processors=2
swap=0
localhostForwarding=true
```

## Networking

```bash
# Find WSL IP address
ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'

# Access Windows localhost from WSL
curl http://host.docker.internal:port

# Access WSL localhost from Windows
curl http://localhost:port  # If using localhostForwarding=true
curl http://wsl-ip:port     # Using WSL IP directly
```

## Integration

```bash
# Launch Windows apps from WSL
explorer.exe .      # Open current directory in File Explorer
code .              # Open current directory in VS Code
notepad.exe file    # Open file in Notepad

# Launch WSL terminal from PowerShell
wt -p "Ubuntu"      # Using Windows Terminal
```

## Docker Integration

```bash
# Enable Docker Desktop WSL 2 integration
# In Docker Desktop: Settings > Resources > WSL Integration

# Run Docker commands in WSL
docker ps
docker run -it ubuntu bash
```

## Common Issues

```powershell
# Fix DNS issues
echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf > /dev/null

# Fix file permissions
sudo chmod 644 filename

# Fix WSL startup errors
wsl --shutdown
wsl --update
```

## Performance Tips

```powershell
# Use WSL file system for better performance
# Avoid working in /mnt/c/ for disk-intensive operations

# Use Windows Terminal for better performance

# Add these to .bashrc or .zshrc for better performance:
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
```