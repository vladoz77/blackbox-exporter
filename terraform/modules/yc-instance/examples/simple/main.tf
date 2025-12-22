/*
Simple example for `yc-instance` module.
Replace placeholder values (image_id, subnet_id, etc.) before applying.
*/

module "vm" {
  source = ".."

  zone = "ru-central1-a"
  name = "example-simple-instance"

  cores  = 2
  memory = 2

  # Path to your public SSH key
  ssh = file("~/.ssh/id_rsa.pub")

  boot_disk = {
    image_id = "fd8...REPLACE_ME_IMAGE_ID..." # <- replace with real image id
    type     = "network-ssd"
    size     = 30
  }

  network_interfaces = [
    {
      subnet_id = "your-subnet-id"
      nat       = true
    }
  ]

  # Example: provide cloud-init content from file in this example folder
  cloud_init = file("${path.module}/cloud_init.yaml")

  create_dns_record = false
}
