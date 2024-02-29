data "local_sensitive_file" "private_ssh_key_azure" {
  filename   = "ansible/private_ssh_key_azure.pem"
  depends_on = [azurerm_linux_virtual_machine.dev_vm_1]
}


# Create private virtual machines
resource "azurerm_linux_virtual_machine" "dev_vm_1" {
  count                 = var.backend_pool_node_count
  name                  = "${var.prefix}_tf_az_vm_${count.index}"
  computer_name         = "devlinuxvm${count.index}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.dev_resource_group.name
  availability_set_id   = azurerm_availability_set.dev_availability_set_1.id
  network_interface_ids = [azurerm_network_interface.dev_nics_1[count.index].id]
  admin_username        = var.username
  size                  = "Standard_B1s"

  os_disk {
    name                 = "devvmosdisk${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

}


# Create a new Availability Set
resource "azurerm_availability_set" "dev_availability_set_1" {
  name                         = "${var.prefix}_availability_set_1"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.dev_resource_group.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 3
}

# Public VM => control node
resource "azurerm_linux_virtual_machine" "ansible_control_node" {
  name                  = "${var.prefix}_ansible_control_node"
  resource_group_name   = azurerm_resource_group.dev_resource_group.name
  computer_name         = "ansiblecontrolnode"
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = var.username
  network_interface_ids = [azurerm_network_interface.dev_nics_control_node_1.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  # Copy ansible folder
  provisioner "file" {
    source      = "ansible"
    destination = "/home/azureadmin"

    connection {
      type        = "ssh"
      user        = var.username
      private_key = data.local_sensitive_file.private_ssh_key_azure.content
      host        = self.public_ip_address
    }
  }

  depends_on = [azurerm_linux_virtual_machine.dev_vm_1]
}

output "control_node_public_ip" {
  value = azurerm_linux_virtual_machine.ansible_control_node.public_ip_address
}


