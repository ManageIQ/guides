```
POST /api/services
```

```json
{
  "action" : "edit",
  "resources" : [
    {
      "href" : "http://localhost:3000/api/services/185",
      "description" : "This is an updated description for service 185"
    },
    {
      "href" : "http://localhost:3000/api/services/185",
      "description" : "This is an updated description for service 186"
    }
  ]
}
```

Back to [Reference Guide](../reference.md)
