
### Users

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/users/1",
  "name": "user1",
  "created_on": "2013-11-18T20:55:26Z",
  "email": "user.one@local.com",
  "lastlogon": "2013-11-18T21:06:57Z",
  "miq_group_id": 1,
  "password_digest": "$2a$10$.wJlAzd7RRL8AbWbYHOpiuWt4uKPRGd/Tsjj2Yu4/JFMeVBUg0Fy.",
  "region": 0,
  "updated_on": "2013-12-11T21:39:05Z",
  "userid": "user1"
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/users/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/users/1"}
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
userid, password, email, miq_group_id
```

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new User |
| edit | Edit a User |
| delete | Delete one or more Users |

##### Add

`POST /api/users`

```json
{
  "action": "add",
  "resource": {
    "name": "John Doe",
    "userid": "jdoe",
    "email": "jdoe@local.com",
    "miq_group_id": 3
  }
}
```

##### Edit

`POST /api/users/1`

```json
{
  "action": "edit",
  "resource": {
    "email": "john.doe@local.com"
  }
}
```

##### Delete

Delete a single Appliance user

`DELETE /api/users/1`

Delete multiple Appliance users

`POST /api/users`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/users/1" },
      { "href" : "http://localhost:3000/api/users/2" }
  ]
}
```


#### Tags

Tags on a User can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.



Back to [Features](./features.md)

Back to [Design Specification](../design.md)

