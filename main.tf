# Azure Provider source and version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "=1.11.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a new resource group
resource "azurerm_resource_group" "dev_resource_group" {
  name     = "${var.prefix}_rg_1"
  location = var.location
}

# Create a new virtual network
resource "azurerm_virtual_network" "dev_virtual_network_1" {
  resource_group_name = azurerm_resource_group.dev_resource_group.name
  name                = "${var.prefix}_vn_1"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
}


# Create 3 new NIC for private VM
resource "azurerm_network_interface" "dev_nics_1" {
  count               = 3
  name                = "${var.prefix}_dev_nic_${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_resource_group.name

  ip_configuration {
    name                          = "host_nic_config"
    subnet_id                     = azurerm_subnet.dev_subnet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# NIC for public control node
resource "azurerm_network_interface" "dev_nics_control_node_1" {
  name                = "${var.prefix}_dev_nic_control_node_1"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_resource_group.name

  ip_configuration {
    name                          = "control_nic_config"
    subnet_id                     = azurerm_subnet.dev_subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev_public_ip_control_node.id
  }
}


