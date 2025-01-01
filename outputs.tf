output "availability_set_id" {
  value = one(azurerm_availability_set.this[*].id)
}

output "network_interface_ids" {
  value = module.network_interface[*].this.id
}

output "public_ips" {
  value = module.network_interface[*].public_ip
}

output "custom_data" {
  value = one(data.cloudinit_config.this[*].rendered)
}