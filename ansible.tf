resource "local_file" "create_inventoy_file" {
  filename = "ansible/inventory.ini"
  content  = <<-EOT
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
    [linuxweb]
    %{for instance in azurerm_linux_virtual_machine.dev_vm_1~}
    ${instance.private_ip_address} ansible_user=azureadmin
    %{endfor~}
  EOT
}

output "private_ip_addresses" {
  value = [for instance in azurerm_linux_virtual_machine.dev_vm_1 : instance.private_ip_address]
}