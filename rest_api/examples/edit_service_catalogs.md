## Edit Multiple Service Catalogs

```
POST /api/service_catalogs
```

```json
{
   "action" : "edit",
   "resources" : [
     {
       "href" : "http://localhost:3000/api/service_catalogs/2",
       "description" : "Updated Description for Second Service Catalog"
     },
     {
       "href" : "http://localhost:3000/api/service_catalogs/3",
       "description" : "Updated Description for Third Service Catalog"
     }
   ]
}
```

Back to [Reference Guide](../reference.md)
