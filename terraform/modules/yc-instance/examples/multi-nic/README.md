Multi-NIC + DNS example

This example demonstrates:
- Multiple network interfaces (one with NAT, one internal static IP).
- Additional disk attached to the instance.
- Creating a DNS record via the module (`create_dns_record = true`).

Before running:
- Replace `boot_disk.image_id`, both `subnet_id` values and `dns_zone_id` with real IDs.
- Ensure you have permission to create DNS records in the specified zone.

Run:

```bash
terraform init
terraform plan
terraform apply
```

Notes:
- The `dns_records` map structure must match the module variable type: `map(object({ name = string, ttl = number, type = string }))`.
- The example assigns a fixed private IP to the second interface (`ip_address`) — ensure it does not conflict with existing addresses.
