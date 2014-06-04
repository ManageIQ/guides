
### Policy Profiles

Policy Profiles are sets of policies.  In the Policy Profile resource, the policies are represented as a
subcollection.

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/policy_profiles/1",
  "description": "RHEL Web Server Policy Profile",
  "created_on": "2013-12-05T16:59:28Z",
  "guid": "9a06568e-5dce-11e3-a2d6-b8e85646e742",
  "mode": "control",
  "name": "9a06568e-5dce-11e3-a2d6-b8e85646e742",
  "updated_on": "2013-12-11T06:33:43Z"
  "policies": [
    {"id" : "http://localhost:3000/api/policies/1"},
    {"id" : "http://localhost:3000/api/policies/5"}
  ]
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/policy_profiles/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/policy_profiles/1"}
  ]
}
```

#### Sub Collections

* policies

#### Attributes

`Required`

```
description
```

`Optional`

```
policies
```

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new Policy Profile |
| edit | Edit a Policy Profile |
| delete | Delete one or more Policy Profiles |

##### Add

`POST /api/policy_profiles`

```json
{
  "action": "add",
  "resource": {
    "description" : "Ubuntu Desktop Policy Profile",
    "policies" : [ 
      { "href" : "http://localhost:3000/api/policies/23" }
    ]
  }
}
```

##### Edit


`POST /api/policy_profiles/3`

```json
{
  "action": "add",
  "resource": {
    "description" : "Updated Ubuntu Desktop Policy Profile",
    "policies" : [ 
      { "href" : "http://localhost:3000/api/policies/24" }
    ]
  }
}
```

Editing the policies subcollection directly

`POST /api/policy_profiles/3/



##### Delete

Delete a single existing policy profile

`DELETE /api/policy_profiles/1`

Delete multiple policy profiles

`POST /api/policy_profiles`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/policy_profiles/1" },
      { "href" : "http://localhost:3000/api/policy_profiles/2" }
  ]
}
```

Delete an individual policy from the policy profile

`DELETE /api/policy_profiles/4/policies/24`

Delete multiple policies from the policy profile

`POST /api/policy_profiles/4/policies`

```json
{
  "action" : "delete"
  "resources" : [
    { "href" : "http://localhost:3000/api/policies/24" },
    { "href" : "http://localhost:3000/api/policies/29" }
  ]
}
```


Back to [Features](./features.md)

Back to [Design Specification](../design.md)

