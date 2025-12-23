############################
# NSG PARA SUBNET AKS
############################
resource "azurerm_network_security_group" "nsg_aks" {
  name                = "nsg-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Permitir HTTP desde Internet (backend expuesto)
  security_rule {
    name                       = "Allow_HTTP_Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_port_range     = "80"
    source_port_range          = "*"
    destination_address_prefix = "*"
  }

  # Permitir HTTPS (si luego usas TLS / Ingress)
  security_rule {
    name                       = "Allow_HTTPS_Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    source_port_range          = "*"
    destination_address_prefix = "*"
  }

  # Permitir salida hacia MySQL (puerto 3306)
  security_rule {
    name                       = "Allow_MySQL_Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "3306"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.snet_db.address_prefixes[0]
  }

  # Permitir salida hacia Storage (HTTPS)
  security_rule {
    name                       = "Allow_Storage_Outbound"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "443"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.snet_storage.address_prefixes[0]
  }

  # Permitir salida necesaria para AKS
  security_rule {
    name                       = "Allow_All_Outbound"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

#resource "azurerm_subnet_network_security_group_association" "aks_nsg_assoc" {
#  subnet_id                 = azurerm_subnet.snet_aks.id
#  network_security_group_id = azurerm_network_security_group.nsg_aks.id
#}

############################
# NSG PARA SUBNET DB (MySQL)
############################
resource "azurerm_network_security_group" "nsg_db" {
  name                = "nsg-db"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Permitir MySQL solo desde AKS
  security_rule {
    name                       = "Allow_MySQL_From_AKS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = azurerm_subnet.snet_aks.address_prefixes[0]
    destination_port_range     = "3306"
    source_port_range          = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "db_nsg_assoc" {
  subnet_id                 = azurerm_subnet.snet_db.id
  network_security_group_id = azurerm_network_security_group.nsg_db.id
}

############################
# NSG PARA SUBNET STORAGE
############################
resource "azurerm_network_security_group" "nsg_storage" {
  name                = "nsg-storage"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Permitir acceso al Storage solo desde AKS (HTTPS)
  security_rule {
    name                       = "Allow_Storage_From_AKS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = azurerm_subnet.snet_aks.address_prefixes[0]
    destination_port_range     = "443"
    source_port_range          = "*"
    destination_address_prefix = "*"
  }
}

#resource "azurerm_subnet_network_security_group_association" "storage_nsg_assoc" {
#  subnet_id                 = azurerm_subnet.snet_storage.id
#  network_security_group_id = azurerm_network_security_group.nsg_storage.id
#}
