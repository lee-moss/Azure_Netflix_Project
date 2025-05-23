#!/bin/bash

# Log file for debugging
LOGFILE="/var/log/prometheus_grafana_setup.log"
exec > >(tee -a $LOGFILE) 2>&1

echo "Starting Prometheus and Grafana installation setup at $(date)"

# Function for error handling
handle_error() {
    echo "ERROR: $1" >&2
    exit 1
}

# Install PowerShell if not already installed
if ! command -v pwsh &> /dev/null; then
    echo "Installing PowerShell..."
    # Update package lists
    apt-get update || handle_error "Failed to update package lists"
    
    # Install prerequisites
    apt-get install -y wget apt-transport-https software-properties-common || handle_error "Failed to install prerequisites"
    
    # Download the Microsoft repository GPG keys
    wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb || handle_error "Failed to download Microsoft GPG keys"
    
    # Register the Microsoft repository GPG keys
    dpkg -i packages-microsoft-prod.deb || handle_error "Failed to register Microsoft GPG keys"
    
    # Update the list of products
    apt-get update || handle_error "Failed to update package lists after adding Microsoft repository"
    
    # Install PowerShell
    apt-get install -y powershell || handle_error "Failed to install PowerShell"
    
    echo "PowerShell installed successfully"
else
    echo "PowerShell is already installed"
fi

# Create the directory for the script if it doesn't exist
SCRIPT_DIR="/opt/prometheus_grafana"
mkdir -p $SCRIPT_DIR || handle_error "Failed to create script directory"

# Create the PowerShell script
cat > $SCRIPT_DIR/prom_and_graf.ps1 << 'EOF' || handle_error "Failed to create PowerShell script"
#!/usr/bin/pwsh

<#
.SYNOPSIS
    Install Prometheus and Grafana on Ubuntu
.DESCRIPTION
    This script installs and configures Prometheus, Grafana, and Node Exporter
.NOTES
    Created: [21/01/2025]
    Version: 1.0
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Versions and paths
$PROMETHEUS_VERSION = "2.45.0"
$NODE_EXPORTER_VERSION = "1.6.1"
$PROMETHEUS_DIR = "/etc/prometheus"
$PROMETHEUS_USER = "prometheus"

# Check if running as root
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

function Install-Prometheus {
    Write-Host "Installing Prometheus..." -ForegroundColor Green
    
    # Create prometheus user
    sudo useradd --no-create-home --shell /bin/false prometheus

    # Create directories
    sudo mkdir -p $PROMETHEUS_DIR
    sudo mkdir -p "$PROMETHEUS_DIR/data"

    # Download and extract Prometheus
    $downloadUrl = "https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz"
    Invoke-WebRequest -Uri $downloadUrl -OutFile "/tmp/prometheus.tar.gz"
    
    tar xvf "/tmp/prometheus.tar.gz" -C /tmp
    sudo cp "/tmp/prometheus-$PROMETHEUS_VERSION.linux-amd64/prometheus" "/usr/local/bin/"
    sudo cp "/tmp/prometheus-$PROMETHEUS_VERSION.linux-amd64/promtool" "/usr/local/bin/"
    
    # Copy config files
    sudo cp -r "/tmp/prometheus-$PROMETHEUS_VERSION.linux-amd64/consoles" $PROMETHEUS_DIR
    sudo cp -r "/tmp/prometheus-$PROMETHEUS_VERSION.linux-amd64/console_libraries" $PROMETHEUS_DIR
    
    # Create prometheus.yml
    $config = @"
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
"@
    $config | Out-File -FilePath "$PROMETHEUS_DIR/prometheus.yml"

    # Set permissions
    sudo chown -R prometheus:prometheus $PROMETHEUS_DIR
    sudo chown prometheus:prometheus /usr/local/bin/prometheus
    sudo chown prometheus:prometheus /usr/local/bin/promtool

    # Create systemd service
    $serviceConfig = @"
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=$PROMETHEUS_DIR/prometheus.yml \
  --storage.tsdb.path=$PROMETHEUS_DIR/data \
  --web.console.templates=$PROMETHEUS_DIR/consoles \
  --web.console.libraries=$PROMETHEUS_DIR/console_libraries

[Install]
WantedBy=multi-user.target
"@
    $serviceConfig | Out-File -FilePath "/etc/systemd/system/prometheus.service"

    # Start service
    sudo systemctl daemon-reload
    sudo systemctl enable prometheus
    sudo systemctl start prometheus
}

function Install-NodeExporter {
    Write-Host "Installing Node Exporter..." -ForegroundColor Green
    
    # Create node_exporter user
    sudo useradd --no-create-home --shell /bin/false node_exporter

    # Download and install node_exporter
    $downloadUrl = "https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz"
    Invoke-WebRequest -Uri $downloadUrl -OutFile "/tmp/node_exporter.tar.gz"
    
    tar xvf "/tmp/node_exporter.tar.gz" -C /tmp
    sudo cp "/tmp/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64/node_exporter" "/usr/local/bin/"
    sudo chown node_exporter:node_exporter "/usr/local/bin/node_exporter"

    # Create systemd service
    $serviceConfig = @"
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
"@
    $serviceConfig | Out-File -FilePath "/etc/systemd/system/node_exporter.service"

    # Start service
    sudo systemctl daemon-reload
    sudo systemctl enable node_exporter
    sudo systemctl start node_exporter
}

function Install-Grafana {
    Write-Host "Installing Grafana..." -ForegroundColor Green
    
    # Add Grafana repository
    sudo apt-get install -y software-properties-common
    sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
    echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

    # Install Grafana
    sudo apt-get update
    sudo apt-get install -y grafana

    # Start service
    sudo systemctl daemon-reload
    sudo systemctl enable grafana-server
    sudo systemctl start grafana-server
}

# Main installation
try {
    Write-Host "Starting installation..." -ForegroundColor Green
    Install-Prometheus
    Install-NodeExporter
    Install-Grafana
    
    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host "Prometheus: http://localhost:9090" -ForegroundColor Yellow
    Write-Host "Node Exporter: http://localhost:9100" -ForegroundColor Yellow
    Write-Host "Grafana: http://localhost:3000" -ForegroundColor Yellow
} catch {
    Write-Error "Installation failed: $_"
    exit 1
}
EOF

# Make the script executable
chmod +x $SCRIPT_DIR/prom_and_graf.ps1 || handle_error "Failed to make script executable"

# Run the PowerShell script with sudo
echo "Running Prometheus and Grafana installation script..."
sudo pwsh $SCRIPT_DIR/prom_and_graf.ps1 || handle_error "PowerShell script execution failed"

echo "Setup completed at $(date)" 