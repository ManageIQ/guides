## Assign Tags to a Service

```
POST /api/services/1/tags
```

```json
{
  "action" : "assign",
  "resources" : [
    { "category" : "location", "name" : "ny" },
    { "category" : "department", "name" : "finance" },
    { "category" : "environment", "name" : "dev" }
  ]
}
```

## Assign Tags by Name to a Service

```
POST /api/services/1/tags
```

```json
{
  "action" : "assign",
  "resources" : [
    { "name" : "/department/finance" },
    { "name" : "/location/ny" }
  ]
}
```

## Assign a Tag by Reference to a Service

```
POST /api/services/1/tags
```

```json
{
  "action" : "assign",
  "resources" : [
    { "href" : "http://localhost:3000/api/services/1/tags/49" }
  ]
}
```

Back to [Reference Guide](../reference.md)
