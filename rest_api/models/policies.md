
### Policies

Policies are a combination of an event, a condition, and and action used to manage a virtual machine.

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/policies/1",
  "name": "474faf28-6227-11e3-adda-b8e85646e742",
  "active": true,
  "created_by": "admin",
  "created_on": "2013-12-11T05:44:19Z",
  "description": "Test Host Compliance Policy",
  "guid": "474faf28-6227-11e3-adda-b8e85646e742",
  "mode": "compliance",
  "towhat": "Host",
  "updated_by": "admin",
  "updated_on": "2013-12-11T05:44:19Z"
  }
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/policies/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/policies/1"}
  ]
}
```

#### Attributes

`Required`

```
description
```

`Optional`

```
mode=compliance, towhat=Vm
```

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new Host or VM Compliance or Control Policy |
| edit | Edit a Policy |
| delete | Delete one or more Policies |

##### Add

`POST /api/policies`

```json
{
  "action": "add",
  "resource": {
    "description" : "Test Vm Compliance Policy"
    "mode": "compliance",
    "towhat": "Vm",
    ...
  }
}
```

#### Delete

Delete a single existing policy

`DELETE /api/policies/1`

Delete multiple policies

`POST /api/policies`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/policies/1" },
      { "href" : "http://localhost:3000/api/policies/2" }
  ]
}
```

#### Policies in a Resource

Policies assigned to a specific resource can be accessed as a subcollection. We will use Hosts
as an example here.

```json
{
  "id": "http://localhost:3000/api/hosts/1",
  "name": "super host",
  "policies" : [ 
    {
      "id" : "http://localhost:3000/api/policies/2" 
      "description": "super policy 2",
      "guid": "6beb1c62-5dce-11e3-a2d6-b8e85646e742"
    }
    ...
  ]
}
```

##### Actions

###### Add

`POST /api/hosts/:id/policies`

```json
{
  "action": "add",
  "resources": [
    { "href" : "http://localhost:3000/api/policies/1" },
    { "href" : "http://localhost:3000/api/policies/4" }
  ]
}
```

###### Delete

Delete multiple policies from a host

`POST /api/services/:id/policies`

```json
{
  "action" : "delete"
  "resources" : [
    { "href" : "http://localhost:3000/api/policies/2" },
    { "href" : "http://localhost:3000/api/policies/3" }
  ]
}
```


Back to [Features](./features.md)

Back to [Design Specification](../design.md)

