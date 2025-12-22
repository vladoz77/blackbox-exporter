output "monitoring_public_ip" {
  value = try(module.monitoring[*].public_ips, [])
}
output "blackbox_public_ip" {
  value = try(module.blackbox[*].public_ips, [])
}

output "monitoring_fqdn" {
  description = "Full FQDN of instances managed by monitoring module"
  value = flatten([
    for instance in module.monitoring : [
      for name in instance.fqdn : [
        "${name}.${data.yandex_dns_zone.zone.name}"
      ]
    ]
  ])
}

output "blackbox_fqdn" {
  description = "Full FQDN of instances managed by blackbox module"
  value = flatten([
    for instance in module.blackbox : [
      for name in instance.fqdn : [
        "${name}.${data.yandex_dns_zone.zone.name}"
      ]
    ]
  ])
}