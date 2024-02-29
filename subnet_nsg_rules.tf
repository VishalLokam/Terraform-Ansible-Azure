
# subnet
resource "azurerm_subnet" "dev_subnet_1" {
  name                 = "${var.prefix}_subnet_1"
  virtual_network_name = azurerm_virtual_network.dev_virtual_network_1.name
  resource_group_name  = azurerm_resource_group.dev_resource_group.name
  address_prefixes     = ["10.0.1.0/24"]
}


# NSG to associate with Subnet
resource "azurerm_network_security_group" "dev_subnet_1_nsg_1" {
  name                = "${var.prefix}_nsg_1"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_resource_group.name
}

# Associate NSG and subnet
resource "azurerm_subnet_network_security_group_association" "dev_subnet_nsg_association_1" {
  network_security_group_id = azurerm_network_security_group.dev_subnet_1_nsg_1.id
  subnet_id                 = azurerm_subnet.dev_subnet_1.id
}


# network security rule to associate with NSG
resource "azurerm_network_security_rule" "dev_nsg_1_rule-1" {
  name                        = "${var.prefix}_nsg_1_rule_1"
  network_security_group_name = azurerm_network_security_group.dev_subnet_1_nsg_1.name
  resource_group_name         = azurerm_resource_group.dev_resource_group.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"

  depends_on = [azurerm_network_security_group.dev_subnet_1_nsg_1]
}