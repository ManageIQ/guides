
### Clusters

Hosts that run the Provider software like RHEV or VmWare vCenter are grouped together to form high availability
and load balancing clusters.

```json
{
  "id": "http://localhost:3000/api/clusters/1",
  "name": "Test Cluster",
  "emd_id": 1,
  "emd_ref" : "domain-c10309",
  ...
  "actions": [
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/clusters/1"}
  ]
}
```

#### Sub Collections

* tags
* policies

#### Attributes

`Required`

```
id, name, description
```

`Optional`

```
display
```

#### Actions

| Name | Description |
|------|-------------|
| delete | Remove one or more Clusters from the VMDB |

##### Delete

Delete a single existing cluster

`DELETE /api/clusters/1`

Delete multiple clusters

`POST /api/clusters`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/clusters/1" },
      { "href" : "http://localhost:3000/api/clusters/2" }
  ]
}
```

#### Tags

Tags on a Cluster can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.

#### Policies

Policies on a Cluster can be accessed as a subcollection. Please refer to the [Policies in a Resource](./policies.md) section for reference.


Back to [Features](./features.md)

Back to [Design Specification](../design.md)
