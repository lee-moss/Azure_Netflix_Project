# Azure Netflix Clone Infrastructure

THIS IS AN ONGOING PROJECT AND WILL BE UPDATED FREQUENTLY

This project contains the Infrastructure as Code (IaC) for deploying a Netflix clone application on Azure using Terraform and Azure DevOps for CI/CD.

![Infrastructure Diagram](diagram.png)

## Prerequisites

- Azure Subscription
- Azure DevOps Organization
- GitHub Account
- Terraform (latest version)
- Azure CLI
- SonarQube Cloud Account

## Project Structure

```
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable definitions
├── terraform.tfvars     # Variable values (do not commit sensitive data)
├── backend.tf           # Backend configuration for state management
├── azure-pipelines.yml  # Azure DevOps pipeline definition
├── cloud-init.yaml      # Cloud-init script for VM deployment
├── vm_startup.sh        # Bash script for Prometheus/Grafana setup
└── modules/             # Terraform modules
    ├── compute/         # VM and compute resources
    ├── keyvault/        # Key Vault configuration
    ├── kubernetes/      # AKS cluster setup
    ├── monitoring/      # Prometheus and Grafana
    ├── networking/      # VNet, subnets, NSG, NAT
    └── security/        # Security configurations
```

## Module Structure

Each module contains:
- `main.tf` - Main module configuration
- `variables.tf` - Module input variables
- `outputs.tf` - Module outputs

### Key Modules

1. **Networking Module**
   - Virtual Network with multiple subnets
   - Network Security Groups
   - NAT Gateway for outbound traffic

2. **Compute Module**
   - Linux VM configuration
   - Network interface
   - SSH key management

3. **Security Module**
   - Key Vault setup
   - Access policies
   - Secret management

4. **Kubernetes Module**
   - AKS cluster configuration
   - Node pools
   - Monitoring add-on

5. **Monitoring Module**
   - Prometheus setup
   - Grafana configuration
   - Storage account for metrics

## Setting Up the Pipeline

1. **Fork/Clone the Repository**
   ```bash
   git clone https://github.com/your-username/Azure_Netflix_Project.git
   cd Azure_Netflix_Project
   ```

2. **Create Azure DevOps Project**
   - Go to dev.azure.com
   - Create a new project
   - Name it appropriately (e.g., "Azure-Netflix")

3. **Configure Service Connections**
   - Go to Project Settings > Service Connections
   - Create "devOps-connection" for Azure Resource Manager
   - Create "GitHub" connection for your repository
   - Create "SonarCloud" connection if using code analysis

4. **Set Up Variable Group**
   - Go to Pipelines > Library
   - Create a variable group named "netflix-variables"
   - Add the following variables:
     - `admin_username` (your VM admin username)
     - `admin_password` (mark as secret)
     - `my_ip_address` (your IP for NSG rules)

5. **Configure Pipeline**
   - Go to Pipelines > New Pipeline
   - Select GitHub as source
   - Select your repository
   - Choose "Existing Azure Pipelines YAML file"
   - Select azure-pipelines.yml

## Pipeline Stages

1. **Analysis**
   - Runs SonarCloud analysis for code quality
   - Publishes quality gate results

2. **Validate and Plan**
   - Initializes Terraform
   - Creates execution plan
   - Validates infrastructure changes

3. **Deploy (Optional)**
   - Applies the Terraform plan
   - Deploys infrastructure to Azure
   - Currently commented out for safety

## Infrastructure Components

- Virtual Network with multiple subnets
- Network Security Groups
- NAT Gateway
- Linux VM with:
  - SSH access (secured by IP restriction)
  - Prometheus monitoring
  - Grafana dashboards
- Azure Key Vault for secrets
- AKS cluster for containerised workloads

## Security Features

- SSH key authentication (password auth disabled)
- IP-restricted access
- Secrets stored in Key Vault
- Network security groups with minimal required ports

## Making Changes

1. Update your IP address in variables if needed
2. Make infrastructure changes in Terraform files
3. Commit and push to GitHub
4. Pipeline will automatically:
   - Validate changes
   - Run security checks
   - Plan the deployment

## Automated Monitoring Stack

This project includes a Docker Compose-based monitoring stack that automatically deploys Prometheus, Node Exporter, and Grafana. The stack is configured to start automatically when the VM is deployed using cloud-init.

### Components

- **Prometheus**: Metrics collection and storage (port 9090)
- **Node Exporter**: System metrics collection (port 9100)
- **Grafana**: Metrics visualization and dashboards (port 3000)

### Local Development Setup

1. **Prerequisites**:
   - Docker
   - Docker Compose

2. **Quick Start**:
   ```bash
   cd monitoring
   docker-compose up -d
   ```

3. **Access the Services**:
   - Grafana: http://localhost:3000 (default login: admin/admin)
   - Prometheus: http://localhost:9090
   - Node Exporter metrics: http://localhost:9100/metrics

### Production Deployment

The monitoring stack is automatically deployed to VMs using cloud-init:

1. The `cloud-init.yaml` file:
   - Installs Docker and Docker Compose
   - Sets up the monitoring directory
   - Deploys the monitoring stack
   - Configures automatic startup on boot

2. **Verification**:
   ```bash
   # Check container status
   docker-compose ps
   
   # View logs
   docker-compose logs
   
   # View logs for a specific service
   docker-compose logs prometheus
   ```

3. **Access Production Services**:
   - Grafana: http://your-vm-ip:3000
   - Prometheus: http://your-vm-ip:9090
   - Node Exporter: http://your-vm-ip:9100

### Security Notes

1. **Important**: Change the default Grafana password on first login
2. The monitoring stack uses Docker volumes for persistence:
   - `prometheus-data`: Stores Prometheus time-series data
   - `grafana-storage`: Stores Grafana dashboards and settings
3. All services are configured to restart automatically

### Customization

1. **Prometheus**:
   - Edit `prometheus.yml` to add more scrape targets
   - Adjust retention settings in docker-compose.yml

2. **Grafana**:
   - Import dashboards (Node Exporter Dashboard ID: 1860)
   - Add Prometheus data source (URL: http://prometheus:9090)
   - Configure additional data sources

3. **Node Exporter**:
   - Customize collectors in docker-compose.yml
   - Add or remove mounted volumes for metrics collection

## Key Technologies and Tools

- Azure DevOps
- Terraform
- Bash
- Docker
- Kubernetes
- Grafana
- Prometheus
- SonarQube Cloud
- Node Exporter

## Notes

- The Deploy stage is commented out by default
- Uncomment it when ready for automated deployments
- Always review the plan before applying changes
- Keep terraform.tfvars out of source control

## Monitoring

- Prometheus available on port 9090
- Grafana dashboards on port 3000
- Node Exporter metrics on port 9100

# Monitoring Stack

This repository contains a Docker Compose setup for a monitoring stack including:
- Prometheus (metrics collection)
- Node Exporter (system metrics)
- Grafana (visualization)

## Quick Start

1. Start the stack:
```bash
docker-compose up -d
```

2. Access the services:
- Prometheus: http://localhost:9090
- Node Exporter: http://localhost:9100/metrics
- Grafana: http://localhost:3000 (default login: admin/admin)

3. Configure Grafana:
- Add Prometheus data source (URL: http://prometheus:9090)
- Import Node Exporter dashboard (ID: 1860)

## File Structure

- `docker-compose.yml`: Service definitions
- `prometheus.yml`: Prometheus configuration

## Persistence

Data is stored in Docker volumes:
- `prometheus-data`: Prometheus time series data
- `grafana-storage`: Grafana dashboards and settings

