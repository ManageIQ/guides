## Example Queries

### Query All VMs

```
GET /api/vms
```

### Query A Specific VM

```
GET /api/vms/1386
```

### Query all VMs, but return only return name and vendor

```
GET /api/vms?expand=resources&attributes=name,vendor
```

### Query VMs named sample* and return name and vendor

```
GET /api/vms?expand=resources&attributes=name,vendor&sqlfilter="name LIKE 'sample%'"
```

### Query VMs but only return the first 500

```
GET /api/vms?offset=0&limit=500
```

### Query VMs but return the second 500

```
GET /api/vms?offset=500&limit=500
```

### Query first 1000 VMs, named test*, get name, vendor and guid and sort by name in ascending order

```
GET /api/vms?offset=0&limit=1000&sqlfilter="name LIKE 'test*'"&expand=resources&attributes=name,vendor,guid&sort_by=name&sort_order=asc
```

### Query Services tagged for the finance department

```
GET /api/services?by_tag=/department/finance
```

### Get details on the Tags of the first service

```
GET /api/services/1/tags?expand=resources
```

### Get of the first service catalog and get details on the assigned service templates

```
GET /api/service_catalogs/1?expand=service_templates
```

Back to [Reference Guide](../reference.md)
