## Unassign service templates from Service Catalog 2

```
POST /api/service_catalogs/2/service_templates
```

```
{
  "action" : "unassign",
  "resources" : [
    { "href" : "http://localhost:3000/api/service_templates/2" },
    { "href" : "http://localhost:3000/api/service_templates/3" },
    { "href" : "http://localhost:3000/api/service_templates/4" }
  ]
}
```

Back to [Reference Guide](../reference.md)
