resource "azurerm_virtual_network" "vnet_dev_calicot" {
  name                = "vnet-dev-calicot-cc-${var.unique_code}"
  location            = "Canada Central"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "development"
  }
}

resource "azurerm_subnet" "snet_dev_web" {
  name                 = "snet-dev-web-cc-${var.unique_code}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_dev_calicot.name
  address_prefixes     = ["10.0.1.0/24"]

  service_endpoints = ["Microsoft.Web", "Microsoft.Storage"]
}

resource "azurerm_subnet" "snet_dev_db" {
  name                 = "snet-dev-db-cc-${var.unique_code}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_dev_calicot.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsg_web" {
  name                = "nsg-dev-web-cc-${var.unique_code}"
  location            = "Canada Central"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_db" {
  name                = "nsg-dev-db-cc-${var.unique_code}"
  location            = "Canada Central"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-db"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "snet_nsg_web" {
  subnet_id                 = azurerm_subnet.snet_dev_web.id
  network_security_group_id = azurerm_network_security_group.nsg_web.id
}

resource "azurerm_subnet_network_security_group_association" "snet_nsg_db" {
  subnet_id                 = azurerm_subnet.snet_dev_db.id
  network_security_group_id = azurerm_network_security_group.nsg_db.id
}
