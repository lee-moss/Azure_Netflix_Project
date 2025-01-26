output storage_account_id {
  description = "ID of the monitoring storage account"
  value       = azurerm_storage_account.monitoring.id
}

output prometheus_container_name {
  description = "Name of the Prometheus data container"
  value       = azurerm_storage_container.prometheus.name
}

output grafana_container_name {
  description = "Name of the Grafana data container"
  value       = azurerm_storage_container.grafana.name
}

output storage_account_name {
  description = "Name of the storage account"
  value       = azurerm_storage_account.monitoring.name
} 