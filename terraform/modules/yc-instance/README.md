**Overview**
- **Описание:**: Terraform-модуль для создания виртуальной машины в Yandex Cloud (YC) с гибкой конфигурацией сетевых интерфейсов, дисков, SSH-ключей и опциональным созданием DNS-записи.

**Requirements**
- **Terraform:**: >= 1.0 (проверить совместимость с вашим workflow).
- **Provider:**: `yandex` (официальный провайдер Yandex Cloud).

**Inputs**
- **`platform_id`**: `string` — yandex instance platform id. Default: `"standard-v1"`.
- **`zone`**: `string` — зона YC (обязательно для задания).
- **`name`**: `string` — имя VM. Default: `"yc-instance"`.
- **`core_fraction`**: `number` — доля CPU. Default: `20`.
- **`cores`**: `number` — количество vCPU. Default: `2`.
- **`memory`**: `number` — объём памяти (в ГБ). Default: `2`.
- **`ssh`**: `string` — публичный SSH-ключ для доступа (nullable).
- **`tags`**: `list(string)` — теги инстанса. Default: `[]`.
- **`network_interfaces`**: `list(object)` — список сетевых интерфейсов с полями `subnet_id`, `nat`, `ip_address` (optional), `security_group` (optional), `static_nat_ip_address` (optional). Default: один интерфейс с пустым `subnet_id` и `nat = true`.
- **`boot_disk`**: `object{ image_id, type, size }` — конфигурация загрузочного диска (обязательно).
- **`additional_disks`**: `list(object{ size, type })` — дополнительные диски (по умолчанию пусто).
- **`labels`**: `map(string)` — метки инстанса (default `{}`).
- **`env_vars`**: `map(string)` — переменные окружения для инстанса (default `{}`).
- **`username`**: `string` — пользователь по умолчанию. Default: `"ubuntu"`.
- **`cloud_init`**: `string` — YAML содержимое для cloud-init (nullable).
- **`create_dns_record`**: `bool` — создать запись DNS для инстанса. Default: `false`.
- **`dns_zone_id`**: `string` — ID DNS-зоны для создания записи (используется если `create_dns_record = true`). Default: `""`.
- **`dns_records`**: `map(object{ name, ttl, type })` — конфигурация DNS-записей (default `{}`).

**Outputs**
- **`instance_id`**: ID созданного инстанса (`yandex_compute_instance.instance.id`).
- **`public_ips`**: публичный IP адрес (NAT) первого сетевого интерфейса.
- **`private_ips`**: приватный IP адрес первого сетевого интерфейса.
- **`tags`**: возвращаемые теги (значение `var.tags`).
- **`instance_name`**: имя инстанса.
- **`fqdn`**: FQDN инстанса, если `create_dns_record = true` (иначе пустой список).

**Example**
- **Простой пример:**

```hcl
module "vm" {
  source = "../../modules/yc-instance"

  zone       = "ru-central1-a"
  name       = "app-server-01"

  boot_disk = {
    image_id = "fd8...your-image-id..."
    type     = "network-ssd"
    size     = 50
  }

  cores     = 2
  memory    = 4

  ````markdown
  **Overview**
  - **Описание:**: Terraform-модуль для создания виртуальной машины в Yandex Cloud (YC) с гибкой конфигурацией сетевых интерфейсов, дисков, SSH-ключей и опциональным созданием DNS-записи.

  **Requirements**
  - **Terraform:**: >= 1.0 (проверить совместимость с вашим workflow).
  - **Provider:**: `yandex` (официальный провайдер Yandex Cloud).

  **Inputs**
  - **`platform_id`**: `string` — yandex instance platform id. Default: `"standard-v1"`.
  - **`zone`**: `string` — зона YC (обязательно для задания).
  - **`name`**: `string` — имя VM. Default: `"yc-instance"`.
  - **`core_fraction`**: `number` — доля CPU. Default: `20`.
  - **`cores`**: `number` — количество vCPU. Default: `2`.
  - **`memory`**: `number` — объём памяти (в ГБ). Default: `2`.
  - **`ssh`**: `string` — публичный SSH-ключ для доступа (nullable).
  - **`tags`**: `list(string)` — теги инстанса. Default: `[]`.
  - **`network_interfaces`**: `list(object)` — список сетевых интерфейсов с полями `subnet_id`, `nat`, `ip_address` (optional), `security_group` (optional), `static_nat_ip_address` (optional). Default: один интерфейс с пустым `subnet_id` и `nat = true`.
  - **`boot_disk`**: `object{ image_id, type, size }` — конфигурация загрузочного диска (обязательно).
  - **`additional_disks`**: `list(object{ size, type })` — дополнительные диски (по умолчанию пусто).
  - **`labels`**: `map(string)` — метки инстанса (default `{}`).
  - **`env_vars`**: `map(string)` — переменные окружения для инстанса (default `{}`).
  - **`username`**: `string` — пользователь по умолчанию. Default: `"ubuntu"`.
  - **`cloud_init`**: `string` — YAML содержимое для cloud-init (nullable).
  - **`create_dns_record`**: `bool` — создать запись DNS для инстанса. Default: `false`.
  - **`dns_zone_id`**: `string` — ID DNS-зоны для создания записи (используется если `create_dns_record = true`). Default: `""`.
  - **`dns_records`**: `map(object{ name, ttl, type })` — конфигурация DNS-записей (default `{}`).

  **Outputs**
  - **`instance_id`**: ID созданного инстанса (`yandex_compute_instance.instance.id`).
  - **`public_ips`**: публичный IP адрес (NAT) первого сетевого интерфейса.
  - **`private_ips`**: приватный IP адрес первого сетевого интерфейса.
  - **`tags`**: возвращаемые теги (значение `var.tags`).
  - **`instance_name`**: имя инстанса.
  - **`fqdn`**: FQDN инстанса, если `create_dns_record = true` (иначе пустой список).

  **Example**
  - **Простой пример:**

  ```hcl
  module "vm" {
    source = "../../modules/yc-instance"

    zone       = "ru-central1-a"
    name       = "app-server-01"

    boot_disk = {
      image_id = "fd8...your-image-id..."
      type     = "network-ssd"
      size     = 50
    }

    cores     = 2
    memory    = 4

    ssh       = file("~/.ssh/id_rsa.pub")

    network_interfaces = [
      {
        subnet_id = "your-subnet-id"
        nat       = true
      }
    ]

    tags = ["app","production"]

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
  ```

  **Usage Notes**
  - **Обязательные поля:**: `zone` и `boot_disk.image_id` должны быть заданы.
  - **SSH:**: укажите `ssh` как содержимое публичного ключа (`file("~/.ssh/id_rsa.pub")`) для доступа по SSH.
  - **cloud_init:**: если используете `cloud_init`, передайте корректный YAML в переменную `cloud_init`.
  - **DNS:**: при включении `create_dns_record` убедитесь, что `dns_zone_id` корректен и у вас есть права на изменение зоны.
  - **Network interfaces:**: модуль поддерживает несколько интерфейсов. Первый интерфейс используется для выходного NAT (`public_ips`/`private_ips`).

  **Тестирование**
  - Инициализация и план проекта (в корне, где используется модуль):

  ```bash
  terraform init
  terraform plan -var-file="terraform.tfvars"
  ```

  - Применение (проверьте переменные и окружение перед запуском):

  ```bash
  terraform apply -var-file="terraform.tfvars"
  ```

  **Где находиться**
  - Модуль: `terraform/modules/yc-instance`

  **Поддержка**
  - Если нужно дополнить README примерами cloud-init или типичными `image_id` для образов, могу добавить — напишите требуемый образ или шаблон cloud-init.

  ---
  Автоматически сгенерированный файл. Внесу дополнения по требованию.

  **Examples**
  - **`examples/simple/`**: минимальный рабочий пример с одним NIC и встроенным `cloud_init.yaml` (см. `examples/simple/main.tf`).
  - **`examples/multi-nic/`**: пример с двумя интерфейсами, дополнительным диском и созданием DNS-записи (см. `examples/multi-nic/main.tf`).

  Run examples (from the example folder):

  ```bash
  terraform init
  terraform plan
  terraform apply
  ```

  Замените все плейсхолдеры (`image_id`, `subnet_id`, `dns_zone_id` и т.д.) перед запуском.
  ````