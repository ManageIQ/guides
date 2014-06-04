
### Service Catalogs

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/service_catalogs/1",
  "name": "TestServices",
  "description" : "Test Services for Test Cluster",
  "servicetemplates" : [
    { "id" : "http://localhost:3000/api/service_templates/11" },
    { "id" : "http://localhost:3000/api/service_templates/12" }
  ]
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/service_catalogs/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/service_catalogs/1"}
  ]
}
```

#### Sub Collections

* service_templates

#### Attributes

`Required`

```
name
```

`Optional`

```
description
```

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new Service Catalog |
| edit | Edit a Service Catalog |
| order | Order a Service from a Service Catalog |
| delete | Remove one or more Service Catalogs from the VMDB |

##### Add

`POST /api/service_catalogs`

```json
{
  "action": "add",
  "resource": {
    "name" : "svccatalog1",
    "description" : "Service Catalog One",
    "service_templates" : [
      { "href" : "http://localhost:3000/api/service_templates/11" },
      { "href" : "http://localhost:3000/api/service_templates/12" },
    ]
  }
}
```

#### Ordering a Single Service

When ordering services, other than the service template identifier, service
attributes and values must be specified as requested by the service designed.

`POST /api/service_catalogs/1/service_templates`

```json
{
  "action": "order",
  "resource" : {
      "href" : "http://localhost:3000/api/service_templates/11",
      "attr1" : "value1",
      "attr2" : "value2",
      ...
  }
}
```

#### Ordering Services

`POST /api/service_catalogs/1/service_templates`

```json
{
  "action": "order",
  "resources" : [
    {
      "href" : "http://localhost:3000/api/service_templates/11",
      "attr1" : "value1",
      "attr2" : "value2",
      ...
    },
    {
      "href" : "http://localhost:3000/api/service_templates/12",
      "attr4" : "value4",
      "attr5" : "value5",
      ...
    }
  ]
}
```

#### Delete

Delete a single service catalog

`DELETE /api/service_catalogs/1`

Delete multiple service catalogs

`POST /api/service_catalogs`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/service_catalogs/1" },
      { "href" : "http://localhost:3000/api/service_catalogs/2" }
  ]
}
```

Delete a service template from a service catalog

`DELETE /api/servicecatalogs/1/service_templates/12`

Delete multiple service templates from a service catalog

`POST /api/servicecatalogs/1/service_templates`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/service_templates/21" },
      { "href" : "http://localhost:3000/api/service_templates/22" }
  ]
}
```


Back to [Features](./features.md)

Back to [Design Specification](../design.md)
