## Retire Service Immediately

```
POST /api/services/301
```

```json
{
  "action" : "retire",
  "resource" : { "href" : "http://localhost:3000/api/services/301" }
}
```

## Retire Service In the Future

```
POST /api/services/302
```

```json
{
  "action" : "retire",
  "resource" : { "href" : "http://localhost:3000/api/services/302", "date" : "06/24/2014", "warn" : "7"  }
}
```


Back to [Reference Guide](../reference.md)
