
### Tags

Resources that may have tags assigned to them can have their tags accessed as a subcollection. In these example we
show accessing tags off a cluster.

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/cluster/1",
  "name": "super cluster",
  "tags" : [ 
    {
      "category" : "category1",
      "name" : "name1"
    },
    {
      "category" : "category2",
      "name" : "name2"
    }
  ]
}
```

#### Queries

Collections can also be queried by a particular tag, so only the resources that have been tagged as such will
be returned.

`GET /api/clusters?by_tag=tag_to_check_for`


#### Actions

##### Assign

`POST /api/cluster/:id/tags`

```json
{
  "action": "assign",
  "resources": [
    {
      "category" : "category3",
      "name" : "name3"
    },
    {
      "category" : "category4",
      "name" : "name4"
    },
    ...
  ]
}
```

#### Delete

Delete multiple tags from a cluster

`POST /api/cluster/:id/tags`

```json
{
  "action" : "unassign"
  "resources" : [
      { "category" : "category2", "name" : "name2" },
      { "category" : "category4", "name" : "name4" }
  ]
}
```




Back to [Features](./features.md)

Back to [Design Specification](../design.md)

