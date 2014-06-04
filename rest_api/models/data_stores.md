
### DataStores

DataStores are storage location for virtual machine files. DataStores can be VMFS volumes, a directory on a Network
Attached Storage device or a path on a local file system.

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/data_stores/62",
  "name": "Dev Datastore",
  "ems_ref": "datastore-1233",
  "directory_hierarchy_supported": true,
  "master": false,
  "multiplehostaccess": 1,
  "raw_disk_mappings_supported": true,
  "store_type": "VMFS",
  "thin_provisioning_supported": true,
  "free_space": 48402268160,
  "total_space": 2134061875200,
  "uncommitted": 696069201920,
  "updated_on": "2013-11-20T14:11:57Z"
  "actions": [
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/data_stores/62"}
  ]
}
```

#### Sub Collections

* tags

#### Actions

| Name | Description |
|------|-------------|
| delete | Delete one or more Data Stores |

##### Delete

Delete a single existing DataStore

`DELETE /api/data_stores/1`

Delete multiple DataStores

`POST /api/data_stores`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/data_stores/62" },
      { "href" : "http://localhost:3000/api/data_stores/63" }
  ]
}
```


#### Tags

Tags on a DataStore can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.


Back to [Features](./features.md)

Back to [Design Specification](../design.md)
