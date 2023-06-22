resource "azurerm_storage_account" "spoke_1" {
  name                = "storageaccountdemofilip"
  resource_group_name = azurerm_resource_group.main.name

  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "top-secret-docs"
  storage_account_name  = azurerm_storage_account.spoke_1.name
  container_access_type = "container"
}

resource "azurerm_storage_account_network_rules" "storageaccountdemofilip" {
  storage_account_id = azurerm_storage_account.spoke_1.id

  default_action             = "Deny"
  ip_rules                   = ["89.23.224.8", "165.225.194.94"]
  bypass                     = ["Metrics"]
}

resource "azurerm_private_endpoint" "storageaccountdemofilip" {
  name                = "Private-Endpoint-SA"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.spoke_1.subnet_id

  private_service_connection {
    name                           = "privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.spoke_1.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.spoke_1.id]
  }
}

resource "azurerm_private_dns_zone" "spoke_1" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  depends_on = [ azurerm_private_dns_zone.spoke_1 ]
  name                  = "storageaccount-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.spoke_1.name
  virtual_network_id    = module.spoke_1.network_id
}
