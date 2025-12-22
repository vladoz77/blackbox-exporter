# Ansible role: blackbox-exporter 🚀

## Описание
**Роль для установки и запуска Prometheus Blackbox Exporter** в Docker через docker-compose. Разворачивает контейнер с конфигурацией из `files/blackbox.yaml` и шаблоном `templates/docker-compose.yaml.j2`.

---

## Особенности ✅

- Размещает файлы в каталоге `{{ "" }}{{ blackbox_exporter_docker_dir }}` (по умолчанию `/home/{{ ansible_user }}/{{ blackbox_exporter_container_name }}`).
- Поддерживает настройку порта, версии образа и политики рестарта.
- Интеграция с Traefik через метки в docker-compose (готово к TLS и базовой аутентификации).

---

## Переменные роли (важные) 🔧

Все значения по умолчанию находятся в `defaults/main.yaml`.

- `blackbox_exporter_repository` (string) — Docker-образ (по умолчанию `prom/blackbox-exporter`).
- `blackbox_exporter_version` (string) — версия образа (по умолчанию `0.28.0`).
- `blackbox_exporter_container_name` (string) — имя контейнера (по умолчанию `blackbox_exporter`).
- `blackbox_exporter_port` (int) — порт контейнера (по умолчанию `9115`).
- `blackbox_exporter_config_path` (string) — путь внутри контейнера к конфигу (по умолчанию `/etc/blackbox-exporter/blackbox.yaml`).
- `blackbox_exporter_docker_dir` (string) — директория на хосте, где будет лежать `docker-compose.yaml` и `blackbox.yaml`.
- `blackbox_exporter_url` (string) — Host для Traefik (например `blackbox.example.com`).
- `blackbox_exporter_basic_auth_enabled` (bool) — включить базовую аутентификацию через Traefik (по умолчанию `false`).
- `blackbox_exporter_basic_auth_username` и `blackbox_exporter_basic_auth_password_hash` — параметры для basic auth при включении.
- `docker_network_name` — имя docker-сети (по умолчанию `blackbox`).

> Все другие значения и комментарии — смотрите в `defaults/main.yaml`.

---

## Файлы роли

- `files/blackbox.yaml` — конфигурация Blackbox Exporter (moduled sample).
- `templates/docker-compose.yaml.j2` — шаблон docker-compose с метками Traefik и опциональной базовой аутентификацией.
- `tasks/main.yaml`, `tasks/install.yaml` — логика проверки и установки/запуска контейнера.

---

## Зависимости ⚠️

- Коллекция Ansible: `community.docker` (для `docker_container_info` и `docker_compose_v2`).
- На хосте должен быть установлен Docker и Docker Compose v2.
- Наличие внешней docker-сети `{{ "" }}{{ docker_network_name }}` (включено в шаблон как external).

---

## Пример использования (playbook) 📋

```yaml
- hosts: blackbox-servers
  become: true
  roles:
    - role: blackbox-exporter
      vars:
        blackbox_exporter_url: "blackbox.example.com"
        blackbox_exporter_basic_auth_enabled: true
        blackbox_exporter_basic_auth_username: "admin"
        # Пароль храните в зашифрованном виде (ansible-vault) — здесь ожидается bcrypt hash
        blackbox_exporter_basic_auth_password_hash: "{{ vault_blackbox_password_hash }}"
```

Или переопределить через `group_vars/`.

---

## Как это работает (коротко) 💡

1. Роль проверяет, запущен ли уже контейнер.
2. Если контейнер не найден/не запущен — создает директорию, копирует `blackbox.yaml` и рендерит `docker-compose.yaml`.
3. Запускает/перезапускает проект через `community.docker.docker_compose_v2`.

---

## Отладка и тестирование 🧪

- Проверьте, что создана папка `{{ "" }}{{ blackbox_exporter_docker_dir }}` и в ней лежат `docker-compose.yaml` и `blackbox.yaml`.
- Просмотрите логи контейнера: `docker compose -f /path/to/docker-compose.yaml logs -f` (или `docker logs <container>`).

---

## Советы по безопасности 🔐

- Храните пароли в `ansible-vault`.
- При использовании Traefik включайте TLS через certresolver.

---

## Лицензия

MIT — используйте по своему усмотрению.

---

Если нужно, могу добавить разделы: метрики, примеры конфигурации `blackbox.yaml` для разных модулей или тестовый playbook для Molecule. ✨
