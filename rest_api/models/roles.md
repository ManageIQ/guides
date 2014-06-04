
### Roles

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/roles/1",
  "created_at": "2013-12-11T07:23:24Z",
  "name": "VmUserGroupRole",
  "read_only": false,
  "settings": {
    "restrictions": {
      "vms": "user_or_group"
    }
  },
  "updated_at": "2013-12-11T07:23:24Z"
  }
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/roles/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/roles/1"}
  ]
}
```

#### Attributes

`Required`

```
name
```

`Optional`

```
settings
```

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new Role |
| edit | Edit a Role |
| delete | Delete one or more Roles |

##### Add

`POST /api/roles`

```json
{
  "action": "add",
  "resource": {
    "name": "VmRole",
    "read_only": false,
    "settings": {
      "restrictions": {
        "vms": "user"
       }
    }
  }
}
```

#### Delete

Delete a single existing user role

`DELETE /api/roles/1`

Delete multiple user roles

`POST /api/roles`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/roles/1" },
      { "href" : "http://localhost:3000/api/roles/2" }
  ]
}
```



Back to [Features](./features.md)

Back to [Design Specification](../design.md)

