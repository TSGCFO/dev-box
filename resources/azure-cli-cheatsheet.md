# Azure CLI Cheat Sheet

## Authentication and Account Management

```bash
# Login to Azure
az login

# List available subscriptions
az account list --output table

# Set active subscription
az account set --subscription "Subscription Name"

# Show current subscription
az account show
```

## Resource Groups

```bash
# Create a resource group
az group create --name myResourceGroup --location eastus

# List resource groups
az group list --output table

# Delete a resource group
az group delete --name myResourceGroup --yes --no-wait
```

## Virtual Machines

```bash
# Create a VM
az vm create --resource-group myResourceGroup --name myVM --image UbuntuLTS --admin-username azureuser --generate-ssh-keys

# List VMs
az vm list --output table

# Start a VM
az vm start --resource-group myResourceGroup --name myVM

# Stop a VM
az vm deallocate --resource-group myResourceGroup --name myVM

# Get VM details
az vm show --resource-group myResourceGroup --name myVM
```

## Azure App Service

```bash
# Create an App Service plan
az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku F1

# Create a web app
az webapp create --name myWebApp --resource-group myResourceGroup --plan myAppServicePlan

# Configure application settings
az webapp config appsettings set --name myWebApp --resource-group myResourceGroup --settings KEY=VALUE

# Deploy code from a GitHub repository
az webapp deployment source config --name myWebApp --resource-group myResourceGroup --repo-url https://github.com/username/repo --branch master --manual-integration
```

## Azure Functions

```bash
# Create a Function App
az functionapp create --name myFunctionApp --resource-group myResourceGroup --consumption-plan-location eastus --storage-account mystorageaccount

# Deploy function from a zip file
az functionapp deployment source config-zip -g myResourceGroup -n myFunctionApp --src path/to/function.zip
```

## Azure SQL Database

```bash
# Create a SQL server
az sql server create --name mySqlServer --resource-group myResourceGroup --location eastus --admin-user adminuser --admin-password P@ssw0rd!

# Create a SQL database
az sql db create --resource-group myResourceGroup --server mySqlServer --name mySqlDb --service-objective S0

# Configure firewall rules
az sql server firewall-rule create --resource-group myResourceGroup --server mySqlServer --name AllowAllIps --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255
```

## Azure Storage

```bash
# Create a storage account
az storage account create --name mystorageaccount --resource-group myResourceGroup --location eastus --sku Standard_LRS

# Create a blob container
az storage container create --name mycontainer --account-name mystorageaccount

# Upload a file to blob storage
az storage blob upload --account-name mystorageaccount --container-name mycontainer --name remoteFileName --file localFilePath
```

## Azure Kubernetes Service (AKS)

```bash
# Create an AKS cluster
az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 2 --enable-addons monitoring --generate-ssh-keys

# Get AKS credentials
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster

# Scale AKS cluster
az aks scale --resource-group myResourceGroup --name myAKSCluster --node-count 3
```

## Dev Center and Dev Box

```bash
# List all Dev Centers
az devcenter admin devcenter list

# List all projects
az devcenter admin project list

# List all Dev Box definitions
az devcenter admin devbox-definition list --resource-group myResourceGroup --dev-center-name myDevCenter

# Create a catalog
az devcenter admin catalog create --dev-center-name myDevCenter --resource-group myResourceGroup --name myCatalog --git-hub-uri https://github.com/username/repo --git-hub-branch main --git-hub-path path/in/repo
```