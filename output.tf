output "blackbox_external_ip" {
  description = "External IP address of the blackbox instance"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "blackbox_instance_id" {
  description = "ID of the blackbox instance"
  value       = yandex_compute_instance.vm.id
}

output "dns_name" {
  description = "DNS name of the blackbox instance"
  value = yandex_dns_recordset.instanse_dns.name
}