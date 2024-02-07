output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "private_subnet_name" {
  value = azurerm_subnet.private.name
}

output "public_subnet_name" {
  value = azurerm_subnet.public.name
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}

output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "private_association" {
  value = azurerm_subnet_network_security_group_association.private.id
}

output "public_association" {
  value = azurerm_subnet_network_security_group_association.public.id
}

