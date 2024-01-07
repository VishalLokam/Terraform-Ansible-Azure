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

  # # Execute the ansible playbook
  # provisioner "remote-exec" {
  #   inline = [
  #     "cd /home/azureadmin/ansible",
  #     "chmod 400 private_ssh_key_azure.pem",
  #     "ansible-playbook -i inventory.ini --private-key=private_ssh_key_azure.pem install_nginx.yaml"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = var.username
  #     private_key = data.local_sensitive_file.private_ssh_key_azure.content
  #     host        = azurerm_linux_virtual_machine.ansible_control_node.public_ip_address
  #   }
  # }

}