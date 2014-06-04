
### Services

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/services/1",
  "name": "first service",
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/services/1"},
    {"name": "retire", "method": "post", "href": "http://localhost:3000/api/services/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/services/1"}
  ]
}
```

#### Sub Collections

* tags

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
| edit | Edit a Service |
| retire | Retire one or more Services |
| delete | Remove one or more Services from the VMDB |

##### Edit

`POST /api/services/1`

```json
{
  "action": "edit",
  "resource": {
     "description" : "Updated Description"
  }
}
```

#### Delete

Delete a single existing service

`DELETE /api/services/1`

Delete multiple services

`POST /api/services`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/services/1" },
      { "href" : "http://localhost:3000/api/services/2" }
  ]
}
```

#### Tags

Tags on a Service can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.



Back to [Features](./features.md)

Back to [Design Specification](../design.md)

