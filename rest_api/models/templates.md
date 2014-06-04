
### VM Templates

Templates are copies of preconfigured virtual machines, designed to capture installed software and software configurations,
as well as the hardware configuration, of the original machines.

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/templates/1",
  "name": "aab-template1",
  "connection_state": "connected",
  "cpu_limit": -1,
  "cpu_reserve": 0,
  "cpu_reserve_expand": false,
  "cpu_shares": 1000,
  "cpu_shares_level": "normal",
  "created_on": "2013-12-11T20:00:21Z",
  "description": "aab-template description",
  "ems_id": 2,
  "ems_ref": "vm-96249",
  "ems_ref_obj": "vm-96249",
  "fault_tolerance": false,
  "evm_owner_id": 2,
  "guid": "ddfc7ca4-629e-11e3-92a2-b8e85646e742",
  "host_id": 3,
  "linked_clone": false,
  "location": "aab-template1/aab-template1.vmtx",
  "memory_limit": -1,
  "memory_reserve": 0,
  "memory_reserve_expand": false,
  "memory_shares": 20480,
  "memory_shares_level": "normal",
  "miq_owner_id": 13,
  "name": "aab-template1",
  "power_state": "never",
  "standby_action": "powerOnSuspend",
  "state_changed_on": "2013-12-11T20:00:21Z",
  "storage_id": 48,
  "template": true,
  "tools_status": "toolsNotInstalled",
  "uid_ems": "422f13e9-85c6-e580-86b9-81dcbe451e14",
  "updated_on": "2013-12-11T20:01:31Z",
  "vdi": false,
  "vendor": "VMware",
  "actions": [
    {"name": "refresh", "method": "post", "href": "http://localhost:3000/api/templates/1"},
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/templates/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/templates/1"}
  ]
}
```

#### Sub Collections

* tags
* policies

#### Attributes

`Required`

```
name
```

`Optional`

```
description, evm_owner_id, miq_group_id
```

#### Actions

| Name | Description |
|------|-------------|
| refresh | Refresh Relationships and Power States |
| edit | Edit a VM Template |
| delete | Remove one or more VM Templates from the VMDB |

##### Edit

Edit a VM Template

`POST /api/templates/1`

```json
{
  "action" : "edit"
  "resource" : {
      "description" : "Template for Third User",
      "evm_owner_id" : 3,
  }
}
```

##### Delete

Delete a single VM Template

`DELETE /api/templates/1`

Delete multiple VM Templates

`POST /api/templates`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/templates/1" },
      { "href" : "http://localhost:3000/api/templates/2" }
  ]
}
```


#### Tags

Tags on a Template can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.

#### Policies

Policies on a Template can be accessed as a subcollection. Please refer to the [Policies in a Resource](./policies.md) section for reference.


Back to [Features](./features.md)

Back to [Design Specification](../design.md)

