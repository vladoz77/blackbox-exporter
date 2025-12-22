/*
Multi-NIC + DNS example for `yc-instance` module.
Replace placeholders (image_id, subnet ids, dns_zone_id) before applying.
*/

module "vm_multi" {
  source = ".."

  zone = "ru-central1-a"
  name = "example-multi-nic"

  cores  = 4
  memory = 8

  ssh = file("~/.ssh/id_rsa.pub")

  boot_disk = {
    image_id = "fd8...REPLACE_ME_IMAGE_ID..."
    type     = "network-ssd"
    size     = 50
  }

  network_interfaces = [
    {
      subnet_id = "your-subnet-id-1"
      nat       = true
    },
    {
      subnet_id = "your-subnet-id-2"
      nat       = false
      ip_address = "10.10.10.50"
    }
  ]

  additional_disks = [
    { size = 100, type = "network-ssd" }
  ]

  create_dns_record = true
  dns_zone_id       = "your-dns-zone-id"
  dns_records = {
    www = {
      name = "app.example.com."
      ttl  = 300
      type = "A"
    }
  }
}
