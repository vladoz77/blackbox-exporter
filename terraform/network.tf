resource "yandex_vpc_network" "network" {
  name = var.network.name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.network.subnet_name
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [var.network.cidr]
}

