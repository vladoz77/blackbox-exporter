instance = {
  cores       = 2
  memory      = 4
  platform_id = "standard-v1"
  name        = "blackbox-vm"
  image_id    = "fd81hgrcv6lsnkremf32"
}

network = {
  cidr        = "192.168.10.0/24"
  name        = "blackbox-network"
  subnet_name = "blackbox-subnet"
}

dns = {
  record_name = "blackbox.home-local.site."
  ttl         = 300
  type        = "A"
}