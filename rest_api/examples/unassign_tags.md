## Unassign Tags from a Service

```
POST /api/services/1/tags
```

```json
{
  "action" : "unassign",
  "resources" : [
    { "category" : "department", "name" : "finance" },
    { "category" : "environment", "name" : "dev" }
  ]
}
```

## Unassign a Tag by Name from a Service

```
POST /api/services/1/tags
```

```json
{
  "action" : "unassign",
  "resources" : [
    { "name" : "/managed/department/finance" }
  ]
}
```

## Unassign a Tag by Reference from a Service

```
POST /api/services/1/tags
```

```json
{
  "action" : "unassign",
  "resources" : [
    { "href" : "tags/49" }
  ]
}
```

Back to [Reference Guide](../reference.md)
