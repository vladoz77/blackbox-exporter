# Ansible Role: Monitoring Stack

**Monitoring Stack** — это Ansible-роль, которая автоматизирует установку и настройку комплексного решения для мониторинга на основе следующих компонентов:

- **VictoriaMetrics** – высокопроизводительное хранилище метрик.
- **VMAlert** – система алертинга и рекординга правил.
- **Alertmanager** – маршрутизация и управление алертами.
- **Grafana** – визуализация метрик и дашборды.
- **Karma** – удобный UI для работы с алертами из Alertmanager.

Все компоненты устанавливаются через Docker и описываются в `docker-compose.yaml`.

## Основные возможности

- Полностью автоматическая настройка всех сервисов.
- Гибкая активация/деактивация отдельных компонентов через переменные.
- Поддержка кастомных конфигураций:
  - Правила Alertmanager и VMAlert.
  - Дашборды Grafana.
  - Конфиг скрейпинга Prometheus.
- Автоматическое создание сети Docker, volumes и директорий.
- Удобная интеграция между компонентами (через Docker Compose).

## Структура проекта

```
roles/monitoring/
├── defaults
│   └── main.yaml                  # Дефолтные переменные
├── files
│   ├── dashboards                 # JSON-дешборды для Grafana
│   │   ├── victoriametrics.json
│   │   └── vmalert.json
│   └── rules                      # Файлы правил Alertmanager / VMAlert
│       ├── alertmanager-alert.yaml
│       ├── victoriametrics-alert.yaml
│       └── vmalert-alert.yaml
├── requirements.yaml              # Требуемые коллекции
├── tasks
│   ├── alertmanager.yaml          # Задачи для Alertmanager
│   ├── grafana.yaml               # Задачи для Grafana
│   ├── main.yaml                  # Главная точка входа
│   ├── victoriametrics.yaml       # Задачи для VictoriaMetrics
│   └── vmalert.yaml               # Задачи для VMAlert
├── templates
│   ├── alertmanager.yaml.j2       # Шаблон конфига Alertmanager
│   ├── dashboards.yaml.j2         # Шаблон конфига дашбордов Grafana
│   ├── datasources.yaml.j2        # Шаблон источников данных Grafana
│   ├── docker-compose.yaml.j2     # Шаблон Docker Compose
│   └── scrape.yaml.j2             # Шаблон конфига скрейпинга
└── vars
    ├── alertmanager.yaml          # Переменные для Alertmanager
    ├── grafana.yaml               # Переменные для Grafana
    ├── main.yaml                  # Общие параметры
    ├── victoriametrics.yaml       # Переменные для VictoriaMetrics
    └── vmalert.yaml               # Переменные для VMAlert
```

## Основные переменные (`defaults/main.yaml`)

| Переменная | По умолчанию | Описание |
|------------|--------------|----------|
| `work_dir` | `/home/{{ username }}/monitoring` | Рабочая директория на хосте |
| `monitoring_network` | `monitoring_network` | Имя Docker-сети |
| `victoriametrics_enable` | `true` | Включить VictoriaMetrics |
| `vmalert_enable` | `true` | Включить VMAlert |
| `alertmanager_enable` | `true` | Включить Alertmanager |
| `grafana_enable` | `true` | Включить Grafana |
| `karma_enable` | `true` | Включить Karma UI |
| `scrape_interval` | `10s` | Интервал сбора метрик |

Больше переменных доступно в `vars/*.yaml`.

## Как использовать роль

### 1. Установите зависимости

```bash
ansible-galaxy collection install -r roles/monitoring/requirements.yaml
```

### 2. Добавьте роль в ваш playbook

```yaml
- hosts: monitoring_servers
  become: false
  roles:
    - role: monitoring
```

### 3. При необходимости переопределите переменные

Например, в `group_vars` или прямо в playbook'е:

```yaml
vars:
  victoriametrics_port: 8428
  grafana_port: 3000
  scrape_interval: 15s
```

## Что делает роль?

- Устанавливает коллекцию `community.docker`.
- Создаёт необходимые каталоги под данные и конфиги.
- Копирует и генерирует конфигурационные файлы.
- Генерирует шаблон `docker-compose.yaml`.
- Запускает контейнеры с нужными параметрами.
- Настраивает связи между компонентами (например, Grafana → VictoriaMetrics).

## Доступные интерфейсы после применения роли

| Сервис | URL |
|--------|-----|
| VictoriaMetrics | http://<host>:8428 |
| VMAlert | http://<host>:8880 |
| Alertmanager | http://<host>:9093 |
| Grafana | http://<host>:3000 |
| Karma | http://<host>:8080 |

## Обновление и перезапуск

Если изменяется `docker-compose.yaml.j2` или любой другой шаблон, то при повторном запуске роль обновляет конфиг и пересоздаёт контейнеры с флагом `recreate: always`.

## Пример вывода

После применения роли вы получите полностью рабочую систему мониторинга, готовую к использованию. Все компоненты будут интегрированы друг с другом:

- Метрики собираются VictoriaMetrics.
- Алерты формируются через VMAlert и отправляются в Alertmanager.
- Grafana предоставляет визуализацию метрик и алертов.
- Karma показывает текущие алерты в удобном виде.

