resource "yandex_vpc_network" "network" {
  name = var.network.name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.network.subnet_name
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [var.network.cidr]
}

resource "yandex_dns_recordset" "instanse_dns" {
  zone_id = data.yandex_dns_zone.zone.id
  name    = var.dns.record_name
  type    = var.dns.type
  ttl     = var.dns.ttl

  data = [yandex_compute_instance.vm.network_interface[0].nat_ip_address]
}