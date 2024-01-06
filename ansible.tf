# resource "local_file" "ip_address_list" {
#     filename = "inventory.ini"
#     content = azurerm_linux_virtual_machine.dev_vm_1.private_ip_address
# }

output "ip_addresses" {
    value = [ for instance in azurerm_linux_virtual_machine.dev_vm_1: instance.private_ip_address ] 
}