## Assign service templates to Service Catalog 1

```
POST /api/service_catalogs/1/service_templates
```

```json
{
  "action" : "assign",
  "resources" : [
    { "href" : "http://localhost:3000/api/service_templates/5" },
    { "href" : "http://localhost:3000/api/service_templates/6" }
  ]
}
```

Back to [Reference Guide](../reference.md)
