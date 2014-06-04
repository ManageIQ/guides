## Adding a simple Service Catalog

```
POST /api/service_catalogs
```

```json
{
   "action" : "add",
   "resource" : {
        "name" : "Sample Service Catalog",
        "description" : "Description of Sample Service Catalog",
        "service_templates" : [
          { "href" : "http://localhost:3000/api/service_templates/3" },
          { "href" : "http://localhost:3000/api/service_templates/4" }
        ]
   }
}
```

Back to [Reference Guide](../reference.md)
