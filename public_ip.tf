# public ip for load balancer
resource "azurerm_public_ip" "dev_public_ip_1" {
  name                = "${var.location}_public_ip_lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_resource_group.name
  allocation_method   = "Static"
}

# public ip for control node
resource "azurerm_public_ip" "dev_public_ip_control_node" {
  name                = "${var.location}_public_ip_control_node"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_resource_group.name
  allocation_method   = "Dynamic"
}