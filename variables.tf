variable "iam_token" {
  type        = string
  description = "Iam token for yandex account"
  sensitive   = true
}

variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  sensitive   = true
}

variable "folder_id" {
  type        = string
  description = "Yandex folder id"
  sensitive   = true
}

variable "instance" {
  description = "Instance configuration"
  type = object({
    platform_id = string
    name        = string
    memory      = number
    cores       = number
    image_id    = string
  })
  default = {
    platform_id = "standard-v1"
    name        = "blackbox-vm"
    memory      = 4
    cores       = 2
    image_id    = "fd81hgrcv6lsnkremf32"
  }
}

variable "network" {
  description = "Network configuration"
  type = object({
    name        = string
    cidr        = string
    subnet_name = string
  })
  default = {
    name        = "blackbox-network"
    cidr        = "10.0.0.0/16"
    subnet_name = "blackbox-subnet"
  }
}

variable "dns" {
  description = "DNS configuration"
  type = object({
    record_name = string
    ttl         = number
    type        = string
  })
}