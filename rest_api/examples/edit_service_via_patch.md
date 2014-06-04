## Editing a resource via the Patch Method.
### Supported attribute actions include, add, edit and remove.

```
PATCH /api/services/1
```

```json
[
  { "action" : "edit", "path" : "name", "value" : "service_001" },
  { "action" : "remove", "path" : "description"}
]
```

Back to [Reference Guide](../reference.md)
