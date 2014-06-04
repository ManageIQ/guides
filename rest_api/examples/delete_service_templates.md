## Delete multiple service templates

```
POST /api/service_templates
```

```json
{
  "action" : "delete",
  "resources" : [
    { "href" : "http://localhost:3000/api/service_templates/11" },
    { "href" : "http://localhost:3000/api/service_templates/12" }
  ]
}
```

Back to [Reference Guide](../reference.md)
