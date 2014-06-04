```
POST /api/services
```

```json
{
  "action" : "retire",
  "resources" : [
      { "href" : "http://localhost:3000/api/services/280" },
      { "href" : "http://localhost:3000/api/services/281" },
      { "href" : "http://localhost:3000/api/services/282", "date" : "06/30/2014", "warn" : "7" },
      { "href" : "http://localhost:3000/api/services/283", "date" : "06/31/2014", "warn" : "7" },
  ]
}
```

Back to [Reference Guide](../reference.md)
