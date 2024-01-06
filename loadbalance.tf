# load balancer
resource "azurerm_lb" "dev_loadbalancer_1" {
  name                = "${var.prefix}_loadbalance_1"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_resource_group.name

  frontend_ip_configuration {
    name                 = "${var.prefix}_lb_frontend_ip_config"
    public_ip_address_id = azurerm_public_ip.dev_public_ip_1.id
  }
}

# backend address pool for load balancer
resource "azurerm_lb_backend_address_pool" "dev_lb_backend_pool_1" {
  name            = "${var.prefix}_lb_backend_pool_1"
  loadbalancer_id = azurerm_lb.dev_loadbalancer_1.id
}

# health probe to check vm availability
resource "azurerm_lb_probe" "dev_lb_probe_1" {
  name            = var.prefix
  loadbalancer_id = azurerm_lb.dev_loadbalancer_1.id
  port            = 80
}

# Load balance rule
resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.dev_loadbalancer_1.id
  name                           = "LBRule"
  probe_id                       = azurerm_lb_probe.dev_lb_probe_1.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.prefix}_lb_frontend_ip_config"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.dev_lb_backend_pool_1.id]
}

# NIC and backend address pool association
resource "azurerm_network_interface_backend_address_pool_association" "dev_lb_nic_association" {
  count                   = 3
  network_interface_id    = element(azurerm_network_interface.dev_nics_1.*.id, count.index)
  ip_configuration_name   = "host_nic_config"
  backend_address_pool_id = azurerm_lb_backend_address_pool.dev_lb_backend_pool_1.id
}

output "lb_public_ip" {
  value = azurerm_public_ip.dev_public_ip_1.ip_address
}