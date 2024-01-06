resource "local_file" "create_inventoy_file" {
  filename = "inventory.ini"
  content  = <<-EOT
    [linuxweb]
    %{for instance in azurerm_linux_virtual_machine.dev_vm_1~}
    ${instance.private_ip_address} ansible_user=azureadmin
    %{endfor~}
  EOT
}

output "private_ip_addresses" {
  value = [for instance in azurerm_linux_virtual_machine.dev_vm_1 : instance.private_ip_address]
}