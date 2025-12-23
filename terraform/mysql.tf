resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "mysql-cloud-demo"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  administrator_login    = var.mysql_admin_user
  administrator_password = var.mysql_admin_password
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"
  delegated_subnet_id    = azurerm_subnet.snet_db.id
  storage {
    size_gb = 20
  }
}

resource "azurerm_mysql_flexible_database" "db" {
  name                = var.mysql_db_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = azurerm_resource_group.rg.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
