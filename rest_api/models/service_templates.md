
### Service Catalog Items

*Note:* Manages Service Catalog Items (service templates) as well as Service Catalog Bundles (composite service templates)

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/service_templates/1",
  "name": "testsvc1",
  "description": "First Test Service",
  "created_at": "2013-11-22T18:31:32Z",
  "display": true,
  "guid": "4f5d94aa-53a4-11e3-a9c9-b8e85646e742",
  "long_description": "",
  "prov_type": "generic",
  "service_template_catalog_id": 1,
  "service_type": "atomic",
  "updated_at": "2013-11-22T18:31:32Z"
  },
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/service_templates/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/service_templates/1"}
  ]
}
```

#### Sub Collections

* tags

#### Actions

| Name | Description |
|------|-------------|
| edit | Edit a Service Catalog Item or Bundle |
| delete | Remove one or more Service Catalog Items or Bundles from the VMDB |

##### Delete

Delete a single service catalog item

`DELETE /api/service_templates/1`

Delete multiple service catalog items

`POST /api/service_templates`

```
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/service_templates/1" },
      { "href" : "http://localhost:3000/api/service_templates/2" }
  ]
}
```


#### Tags

Tags on a Service Catalog Items can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.



Back to [Features](./features.md)

Back to [Design Specification](../design.md)

