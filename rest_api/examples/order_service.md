## Order a single service from Service Catalog 1

```
POST /api/service_catalogs/1/service_templates
```

```json
{
  "action" : "order",
  "resource" : { 
    "href" : "http://localhost:3000/api/service_templates/3",
    "option_0_vm_target_name" : "test-vm-0001",
    "option_0_vm_target_hostname" : "test-vm-0001"
  }
}
```

Back to [Reference Guide](../reference.md)
