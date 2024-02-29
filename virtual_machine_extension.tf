resource "azurerm_virtual_machine_extension" "dev_vm_extension_1" {
  name                 = "${var.prefix}_vm_extension"
  virtual_machine_id   = azurerm_linux_virtual_machine.ansible_control_node.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  protected_settings = <<PROT
    {
        "script": "${base64encode(file("ansible/install_ansible.sh"))}"
    }
    PROT

}