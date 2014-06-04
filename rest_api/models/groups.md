
### Groups

User groups associate Roles to users. User groups can also have associated filters that are bound to its users.

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/groups/14",
  "description": "Test User Group",
  "guid": "e62dea80-6216-11e3-adda-b8e85646e742",
  "miq_user_role_id": 2,
  "filters": {
    "managed": [
      [
        "/managed/prov_max_cpu/4"
      ]
    ],
    "belongsto": [
      "/belongsto/ExtManagementSystem|RedHat vCenter 5.0/EmsFolder|Datacenters/EmsFolder|Dev/EmsFolder|host/Host|devhost-t1.local.com",
      "/belongsto/ExtManagementSystem|RedHat vCenter 5.0/EmsFolder|Datacenters/EmsFolder|Prod/EmsFolder|vm/EmsFolder|Discovered virtual machine"
    ]
  },
  "updated_on": "2013-12-11T03:47:04Z"
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/groups/14"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/groups/14"}
  ]
}
```

#### Sub Collections

* tags

#### Attributes

`Required`

```
description, miq_user_role_id
```

`Optional`

```
filters
```

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new User Group |
| edit | Edit a User Group |
| delete | Delete one or more User Groups |

##### Add

`POST /api/groups`

```json
{
  "action": "add",
  "resource": {
    "description" : "Guest User Group",
    "miq_user_role_id" : 4
  }
}
```

#### Edit

`POST /api/groups/14`

```json
{
  "action": "edit",
  "resource": {
    "description" : "Administrative User Group",
    "miq_user_role_id" : 1
  }
}
```

#### Delete

Delete a single existing user group

`DELETE /api/groups/1`

Delete multiple groups

`POST /api/groups`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/groups/14" },
      { "href" : "http://localhost:3000/api/groups/15" }
  ]
}
```


#### Tags

Tags on a Group can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.


Back to [Features](./features.md)

Back to [Design Specification](../design.md)
