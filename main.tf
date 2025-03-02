data azurerm_client_config current {}

resource azurerm_resource_group netflix {
  name     = "Azure-Netflix-Project"
  location = "UK West"
}

# Storage for Terraform State
resource azurerm_storage_account tfstate {
  name                     = "tfstatest"
  resource_group_name      = azurerm_resource_group.netflix.name
  location                 = azurerm_resource_group.netflix.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource azurerm_storage_container tfstate {
  name                     = "tfstate"
  storage_account_name     = azurerm_storage_account.tfstate.name
  container_access_type    = "private"
}   

# Networking Module
module networking {
  source = "./modules/networking"

  resource_group_name      = azurerm_resource_group.netflix.name
  location                 = azurerm_resource_group.netflix.location
  my_ip_address            = var.my_ip_address

  vnet_name                = "netflix-network"
  address_space            = ["10.0.0.0/16"]
  aks_subnet_prefix        = "10.0.1.0/24"
  management_subnet_prefix = "10.0.2.0/24"
  db_subnet_prefix         = "10.0.3.0/24"
  pe_subnet_prefix         = "10.0.4.0/24"

  tags = {
    Environment = "Development"
    Project     = "Netflix Project"
    Terraform   = "true"
  }
}

# Security Module
module security {
  source = "./modules/security"

  resource_group_name = azurerm_resource_group.netflix.name
  location            = azurerm_resource_group.netflix.location
  key_vault_name      = var.key_vault_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  admin_object_id     = data.azurerm_client_config.current.object_id
  devops_object_id    = var.devops_object_id
  my_ip_address       = var.my_ip_address

  allowed_subnet_ids  = [module.networking.management_subnet_id]
  admin_username      = var.admin_username
  tmdb_api_key        = var.tmdb_api_key
  tmdb_access_token   = var.tmdb_access_token

  tags = {
    Environment = "Development"
    Project     = "Netflix Clone"
    Terraform   = "true"
  }
}

# Compute Module
module compute {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.netflix.name
  location            = azurerm_resource_group.netflix.location
  subnet_id           = module.networking.management_subnet_id
  key_vault_id        = module.security.key_vault_id
  vm_identity_id      = module.security.vm_identity_id
  admin_username      = var.admin_username

  tags = {
    Environment = "Development"
    Project     = "Netflix Clone"
    Terraform   = "true"
  }
}

# Kubernetes Module
module kubernetes {
  source     = "./modules/kubernetes"
  depends_on = [module.networking, module.security]

  resource_group_name = azurerm_resource_group.netflix.name
  location           = azurerm_resource_group.netflix.location
  cluster_name       = "netflix-aks"
  dns_prefix         = "netflix-aks"
  subnet_id          = module.networking.aks_subnet_id
  acr_id             = module.security.acr_id

  node_count         = 2
  node_size          = "Standard_DS2_v2"
  min_node_count     = 1
  max_node_count     = 5

  tags = {
    Environment = "Development"
    Project     = "Netflix Clone"
    Terraform   = "true"
  }
}