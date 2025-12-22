Simple example

This example demonstrates a minimal usage of the `yc-instance` module.

Steps:

1. Replace placeholders in `main.tf` (notably `boot_disk.image_id` and `network_interfaces[0].subnet_id`).
2. Ensure provider configuration is available (via environment variables or in a provider block).
3. Run:

```bash
terraform init
terraform plan
terraform apply
```

Notes:
- `cloud_init.yaml` in this folder is referenced by `main.tf` and demonstrates a minimal cloud-init.
- Do not commit private keys or actual credentials into the example.
