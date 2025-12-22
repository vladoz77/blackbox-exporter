# blackbox-exporter

Проект содержит Terraform + Ansible конфигурации для развёртывания виртуальных машин в Yandex Cloud и установки сервисов мониторинга (Traefik, VictoriaMetrics, Grafana, Alertmanager, Loki) и Prometheus Blackbox Exporter в Docker через Docker Compose.

## 🔍 Коротко (что делает репозиторий)
- Terraform (`terraform/`) создаёт инфраструктуру: VPC, подсеть, security groups, VM и DNS.
- Terraform генерирует `ansible/inventory.ini` (шаблон `terraform/inventory.tftpl`).
- Ansible (`ansible/`) настраивает ОС, устанавливает Docker, Traefik, Monitoring стек и Blackbox Exporter по ролям (каждая роль рендерит `templates/*.j2` и управляет сервисами через `community.docker.docker_compose_v2`).
- Traefik хранит `acme.json` и поддерживает синхронизацию с Yandex S3 через роль `sync_acme_to_s3`.

---

## ✅ Требования
- Terraform >= 1.9.8
- Ansible (на машине управления)
- На целевых хостах: Docker + Docker Compose v2
- Аккаунт в Yandex Cloud и S3-бакет (для acme/бэкапов)

---

## Быстрый старт (локально)
1. Инициализировать Terraform и применить инфраструктуру:

```bash
cd terraform
terraform init \
  -backend-config="access_key=<ACCESS_KEY>" \
  -backend-config="secret_key=<SECRET_KEY>"
terraform plan -out plan.tfplan
terraform apply "plan.tfplan"
```

2. После apply Terraform сгенерирует `ansible/inventory.ini`. Скачайте его или используйте вывод `terraform output` для доступа.

3. Запуск Ansible (пример):

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yaml \
  -e aws_access_key=<ACME_AWS_ACCESS_KEY> -e aws_secret_key=<ACME_AWS_SECRET> \
  -u ubuntu --ssh-extra-args "-o StrictHostKeyChecking=no"
```

---

## Основные файлы и структуры
- `terraform/` — модули и конфиги для создания VM и сети (см. `terraform/main.tf`, `terraform/modules/yc-instance/`).
- `terraform/inventory.tftpl` → `ansible/inventory.ini`.
- `ansible/playbook.yaml` — включает роли: `common`, `docker`, `traefik`, `monitoring`, `blackbox-exporter`, `sync_acme_to_s3`.
- `ansible/roles/<role>` — каждая роль содержит `defaults/`, `tasks/`, `templates/`, `README.md`.
- `ansible/group_vars/` — группа переменных для `monitoring-server` и `blackbox-server`.
- `.github/workflows/terraform.yml` — CI: terraform init/plan/apply + запуск Ansible.

---

## Проектные соглашения и полезные приёмы
- Роли должны быть idempotent: используйте `tasks/` для проверки и условных операций (пример: `ansible/roles/traefik/tasks/install.yaml`).
- Docker Compose шаблоны помещаются в `templates/*.j2` и обычно используют внешнюю сеть `{{ docker_network_name }}` — указывайте `external` если сеть общая.
- Traefik использует S3 для бэкапа `acme.json` (`s3_bucket_name`, `s3_key`, `aws_access_key`, `aws_secret_key`, `yandex_storage_endpoint`).
- Пароли/ключи — храните в `ansible-vault` и передавайте в playbook через vars / group_vars.
- `monitoring` роль устанавливает ansible-галерею коллекций автоматически (см. `ansible/roles/monitoring/tasks/main.yaml`).

---

## Отладка и часто используемые команды
- Просмотреть сгенерированный inventory:
  - `cat ansible/inventory.ini`
- SSH на VM:
  - `ssh ubuntu@$(terraform output -raw blackbox_external_ip)`
- Проверить docker-compose и логи на хосте:
  - `docker compose -f /home/ubuntu/monitoring/docker-compose.yaml ps`
  - `docker compose -f /home/ubuntu/monitoring/docker-compose.yaml logs -f <service>`
- Traefik ACME в S3:
  - Синхронизация реализована в `ansible/roles/sync_acme_to_s3` — проверьте `s3_bucket_name` и `s3_key` в group_vars.
- Ansible: попробовать playbook локально с `--check` и `--diff` для безопасного теста.

---

## CI и секреты
- Workflow `.github/workflows/terraform.yml` использует `yc-iam-token-fed` для получения IAM token и выполняет terraform/ansible.
- Ожидаемые секреты: `ACCESS_KEY`, `SECRET_KEY`, `TF_VAR_CLOUD_ID`, `TF_VAR_FOLDER_ID`, `YC_SA_ID`, `ACME_AWS_ACCESS_KEY`, `ACME_AWS_SECRET`.

---

## Как добавить новую роль (чеклист)
1. Создать `ansible/roles/<your-service>` с `defaults/`, `templates/`, `tasks/`, `README.md`.
2. Добавить переменные по умолчанию в `defaults/main.yaml`.
3. Рендерить `templates/docker-compose.yaml.j2` и запускать через `community.docker.docker_compose_v2`.
4. Обновить `ansible/playbook.yaml` и `ansible/group_vars` (при необходимости).
5. Документировать в `ansible/roles/<your-service>/README.md` и добавить пример использования.

---


