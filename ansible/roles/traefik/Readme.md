# Ansible Role: Traefik Reverse Proxy

Устанавливает и настраивает Traefik как reverse proxy с автоматическим SSL сертификатами от Let's Encrypt и интеграцией с Yandex Cloud S3 для резервного копирования сертификатов.

## 📋 Requirements

### Target System
- Ubuntu/Debian
- Docker и Docker Compose
- Python 3.x

### Ansible Collections
```bash
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.docker
```

## ⚙️ Role Variables

### Основные настройки
```yaml
# Docker конфигурация
docker_network_name: "bridge"
traefik_container_name: "traefik"
traefik_image: "traefik"
traefik_version: "v3.5"
traefik_docker_dir: "/home/{{ ansible_user }}/traefik"

# Let's Encrypt
acme_email: "your-email@example.com"
```

### Dashboard (опционально)
```yaml
traefik_enable_dashboard: false
traefik_dashboard_url: "traefik.home-local.site"  
traefik_dashboard_user: "admin"
traefik_dashboard_password_hash: "$$apr1$$..."  
```

### Yandex Cloud S3 интеграция
```yaml
yandex_region: "ru-central1"
yandex_storage_endpoint: "https://storage.yandexcloud.net/"
s3_bucket_name: "acme-bucket"
s3_key: "traefik/acme.json"
aws_access_key: "YCAJ..."  # Задать в vault!
aws_secret_key: "YCPM..."  # Задать в vault!
```

## 🚀 Usage

### Basic Installation
```yaml
- hosts: servers
  roles:
    - role: traefik
      vars:
        acme_email: "your-email@example.com"
```

### With Dashboard and S3 Backup
```yaml
- hosts: servers
  vars_files:
    - vault.yml  # С AWS credentials
  roles:
    - role: traefik
      vars:
        acme_email: "admin@company.com"
        traefik_enable_dashboard: true
        traefik_dashboard_url: "traefik.company.com"
        s3_bucket_name: "company-traefik-backup"
```

### For Multiple Domains
```yaml
- hosts: servers
  roles:
    - role: traefik
      vars:
        acme_email: "admin@company.com"
        traefik_dashboard_url: "traefik.internal.company.com"  # Отдельный домен для dashboard
```

## 🔧 Features

### ✅ Автоматическое управление SSL
- Let's Encrypt сертификаты через HTTP challenge
- Автоматическое продление сертификатов
- HTTPS редирект с HTTP

### ✅ Интеграция с Docker
- Автоматическое обнаружение контейнеров
- Docker network поддержка
- Ярлыки для автоматической конфигурации

### ✅ Yandex Cloud S3 Backup
- **Резервное копирование** сертификатов в S3
- **Восстановление** при пересоздании инстанса
- Избежание лимитов Let's Encrypt

### ✅ Dashboard (опционально)
- Web-интерфейс мониторинга
- Базовая аутентификация
- HTTPS доступ
- **Гибкая настройка домена** через `traefik_dashboard_url`

## 📁 Project Structure
```
traefik/
├── defaults/main.yml     # Переменные по умолчанию
├── tasks/
│   ├── main.yml          # Основные задачи
│   └── install.yml       # Установка и настройка
├── templates/
│   └── docker-compose-traefik.yaml.j2  # Docker Compose шаблон
└── meta/main.yml         # Мета-информация роли
```

## 🔒 Security Notes

### Хранение credentials
```bash
# Создать encrypted vault
ansible-vault create group_vars/all.yml

# Содержимое:
aws_access_key: "YCAJ..."
aws_secret_key: "YCPM..."
```

### Безопасность Dashboard
- По умолчанию dashboard отключен (`traefik_enable_dashboard: false`)
- Используйте отдельный домен для dashboard
- Сложные пароли и базовая аутентификация

## 🎯 Key Improvements

### Гибкая настройка доменов
- **Dashboard домен** задается отдельно через `traefik_dashboard_url`
- **Домены приложений** настраиваются в их собственных docker-compose файлах
- Каждый сервис может иметь свой уникальный домен

### Упрощенная конфигурация
- Убрана глобальная переменная `domain_name`
- Более четкое разделение ответственности
- Легче управлять множеством доменов

## 🔄 Workflow

1. **Проверка существования** Traefik контейнера
2. **Остановка конфликтующих** сервисов на портах 80/443
3. **Восстановление сертификатов** из S3 (если доступно)
4. **Развертывание** Traefik через Docker Compose
5. **Автоматическая настройка** SSL сертификатов

## 📝 Example Scenarios

### Single Server Setup
```yaml
- hosts: single-server
  roles:
    - role: traefik
      vars:
        acme_email: "admin@company.com"
        traefik_enable_dashboard: true
        traefik_dashboard_url: "traefik.company.com"
```

### Multi-Service Environment
```yaml
- hosts: proxy-servers
  roles:
    - role: traefik
      vars:
        acme_email: "devops@company.com"
        # Dashboard на отдельном домене
        traefik_enable_dashboard: true
        traefik_dashboard_url: "monitor.internal.company.com"
```

## 🐛 Troubleshooting

### Проверка статуса
```bash
docker logs traefik
docker exec traefik traefik certs list
```

### Проверка Dashboard
```bash
curl -u admin:password https://traefik.home-local.site/api/health
```

### Ручное резервное копирование
```bash
aws s3 cp /home/ubuntu/traefik/letsencrypt/acme.json \
  s3://acme-bucket/traefik/acme.json \
  --endpoint-url https://storage.yandexcloud.net
```

## 🔍 Monitoring

### Логи Traefik
```bash
docker logs -f traefik
```

### Статус сертификатов
```bash
docker exec traefik traefik certs list
```

### Health check Dashboard
```bash
curl -f https://traefik.your-domain.com/api/health
```

## ✅ Benefits

- **Гибкость**: Отдельная настройка домена для dashboard
- **Простота**: Четкое разделение конфигурации
- **Надежность**: Автоматическое резервное копирование сертификатов
- **Безопасность**: HTTPS по умолчанию, изолированный dashboard
- **Масштабируемость**: Поддержка множества доменов и сервисов

---
