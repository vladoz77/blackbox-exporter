output "instance_id" {
  value = yandex_compute_instance.instance.id
}

output "public_ips" {
  value = yandex_compute_instance.instance.network_interface[0].nat_ip_address
}

output "private_ips" {
  value = yandex_compute_instance.instance.network_interface[0].ip_address
}

output "tags" {
  value = var.tags
}

output "instance_name" {
  value = yandex_compute_instance.instance.name
}

output "fqdn" {
  description = "Instance FQDN (if DNS record was created)"
  value       = var.create_dns_record ? values(yandex_dns_recordset.instance_dns)[*].name : []
}