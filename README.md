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

## Automated Prometheus and Grafana Installation

This project includes scripts to automatically install Prometheus and Grafana when deploying a new Ubuntu VM.

### Installation Files

- `cloud-init.yaml`: Cloud-init configuration file to automatically run the installation script during VM deployment
- `vm_startup.sh`: Bash script that installs PowerShell and runs the Prometheus/Grafana installation script
- `prom_and_graf.ps1`: PowerShell script that installs and configures Prometheus, Grafana, and Node Exporter

### Deployment Instructions

#### Azure

When deploying a new Ubuntu VM in Azure, you can use the cloud-init script as follows:

1. In the Azure Portal, start the VM creation process
2. Select an Ubuntu image (18.04 LTS or newer)
3. In the "Advanced" tab, find the "Custom data" section
4. Paste the contents of the `cloud-init.yaml` file
5. Complete the VM creation process

#### AWS

When launching a new Ubuntu instance in AWS:

1. Start the EC2 instance creation process
2. Select an Ubuntu AMI
3. In the "Advanced Details" section, find "User data"
4. Select "As text" and paste the contents of the `cloud-init.yaml` file
5. Complete the instance launch process

#### Google Cloud Platform

When creating a new Ubuntu VM in GCP:

1. Start the VM instance creation process
2. Select an Ubuntu image
3. Expand the "Management, security, disks, networking, sole tenancy" section
4. In the "Management" tab, find "Automation"
5. Paste the contents of the `cloud-init.yaml` file
6. Complete the VM creation process

### Verification

After the VM is deployed, you can verify the installation by:

1. SSH into your VM
2. Check if the services are running:
   ```bash
   sudo systemctl status prometheus
   sudo systemctl status node_exporter
   sudo systemctl status grafana-server
   ```
3. Access the web interfaces (you may need to configure firewall rules to allow these ports):
   - Prometheus: http://your-vm-ip:9090
   - Node Exporter: http://your-vm-ip:9100
   - Grafana: http://your-vm-ip:3000

### Troubleshooting

If you encounter any issues with the Prometheus/Grafana installation, check the installation logs:
```bash
cat /var/log/prometheus_grafana_setup.log
```

### Customization

To customize the Prometheus/Grafana installation:

1. Modify the `cloud-init.yaml` file to change the installation parameters
2. Update the versions in the PowerShell script if you need specific versions of Prometheus or Grafana
3. Add additional exporters or configurations as needed

## Key Technologies and Tools

- Azure DevOps
- Terraform
- Powershell/Bash
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

