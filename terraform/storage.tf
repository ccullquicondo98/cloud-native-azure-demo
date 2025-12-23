resource "azurerm_storage_account" "storage" {
  name                     = "stcloudccdemo"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "objects" {
  name                  = "objects"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
