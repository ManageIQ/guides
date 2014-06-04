## Unassign Tags from service template 1

```
POST /api/service_templates/1/tags
```

```json
{
  "action" : "unassign",
  "resources" : [
    { "category" : "location", "name" : "ny" },
    { "category" : "department", "name" : "finance" }
  ]
}
```

Back to [Reference Guide](../reference.md)
