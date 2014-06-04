
### Resource Pools

Resource Pools are a group of virtual machines across which CPU and memory resources are allocated

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/resource_pools/1",
  "name": "Default for Cluster Test Cluster",
  "cpu_limit": 30970,
  "cpu_reserve": 30970,
  "cpu_reserve_expand": true,
  "cpu_shares": 4000,
  "cpu_shares_level": "normal",
  "created_on": "2013-11-19T00:22:51Z",
  "ems_id": 1,
  "ems_ref": "resgroup-10310",
  "ems_ref_obj": "resgroup-10310",
  "is_default": true,
  "memory_limit": 74155,
  "memory_reserve": 74155,
  "memory_reserve_expand": true,
  "memory_shares": 163840,
  "memory_shares_level": "normal",
  "uid_ems": "resgroup-10310",
  "updated_on": "2013-12-11T01:35:13Z",
  "vapp": false
  "actions": [
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/resource_pools/1"}
  ]
}
```

#### Sub Collections

* tags
* policies

#### Actions

| Name | Description |
|------|-------------|
| delete | Remove one or more Resource Pools from the VMDB |

#### Delete

Delete a single existing resource pool

`DELETE /api/resource_pools/1`

Delete multiple resource pools

`POST /api/resource_pools`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/resource_pools/7" },
      { "href" : "http://localhost:3000/api/resource_pools/9" }
  ]
}
```


#### Tags

Tags on a Resource Pool can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.

#### Policies

Policies on a Resource Pool can be accessed as a subcollection. Please refer to the [Policies in a Resource](./policies.md) section for reference.


Back to [Features](./features.md)

Back to [Design Specification](../design.md)

