
### VMs

A VM (virtual machine) is a realized compute resource that exists in a given
cloud or virtualization service provider. Each VM is comprised of cpu, memory
and storage resources (amongst many other attributes) and can be part of a
created Service.


#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/vms/1",
  "name": "devvm1",
  "boot_time": "2013-11-25T16:53:00Z",
  "connection_state": "connected",
  "cpu_limit": -1,
  "cpu_reserve": 0,
  "cpu_reserve_expand": false,
  "cpu_shares": 4000,
  "cpu_shares_level": "normal",
  "created_on": "2013-12-09T14:27:11Z",
  "ems_cluster_id": 3,
  "ems_id": 2,
  "ems_ref": "vm-94415",
  "ems_ref_obj": "vm-94415",
  "fault_tolerance": false,
  "guid": "fe124ed2-60dd-11e3-a97d-685b357a1e42",
  "host_id": 6,
  "linked_clone": false,
  "location": "tch-rh64-5.2.1.3-DB/tch-rh64-5.2.1.3-DB.vmx",
  "memory_limit": -1,
  "memory_reserve": 0,
  "memory_reserve_expand": false,
  "memory_shares": 61440,
  "memory_shares_level": "normal",
  "power_state": "on",
  "retirement_warn": 7,
  "retires_on": "2013-12-17",
  "standby_action": "checkpoint",
  "state_changed_on": "2013-12-09T14:27:11Z",
  "storage_id": 14,
  "template": false,
  "tools_status": "toolsOk",
  "uid_ems": "422fdc41-681d-57cd-be86-e3b308598747",
  "updated_on": "2013-12-11T19:53:26Z",
  "vdi": false,
  "vendor": "VMware",
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "refresh", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "shutdown", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "restart", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "poweron", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "poweroff", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "suspend", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "reset", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "retire", "method": "post", "href": "http://localhost:3000/api/vms/1"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/vms/1"}
  ]
}
```

#### Sub Collections

* tags
* policies

#### Actions

| Name | Description |
|------|-------------|
| add | Provision a new VM |
| edit | Edit a VM |
| refresh | Refresh Relationships and Power States | 
| shutdown | Shutdown Guest |
| restart | Restart Guest |
| poweron | Power On a VM |
| poweroff | Power Off a VM |
| suspend | Suspend a VM |
| reset | Reset a VM |
| retire | Retire one or more VMs |
| delete | Remove one or more VMs from the VMDB |

##### Add

Create (provision) a new VM resource

`POST /api/vms`

```json
{
  "action": "add",
  "resource": {
    "template": "http://localhost:3000/api/templates/10",
    "name": "newdevvm",
    "host_id": 5,
    "storage_id": 48,
    "email": "jdoe@local.com",
    "first_name": "John",
    "last_name": "Doe"
  }
}
```


#### Start

Start a stopped VM

`POST /api/vms/1`

```json
{
  "action": "start"
}
```

#### Suspend

Suspend several VMs

`POST /api/vms`

```json
{
  "action": "suspend",
  "resources" : [
    { "href" : "http://localhost:3000/api/vms/11" },
    { "href" : "http://localhost:3000/api/vms/12" },
    { "href" : "http://localhost:3000/api/vms/13" },
    { "href" : "http://localhost:3000/api/vms/14" },
    { "href" : "http://localhost:3000/api/vms/15" }
  ]
}
```

##### Delete

Delete an existing VM resource

`DELETE /api/vms/1`

Delete multiple VMs

`POST /api/vms`

```json
{
  "action": "delete"
  "resources" : [
    { "href" : "http://localhost:3000/api/vms/11" },
    { "href" : "http://localhost:3000/api/vms/12" }
  ]
}
```


#### Tags

Tags on a VM can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.

#### Policies

Policies on a VM can be accessed as a subcollection. Please refer to the [Policies in a Resource](./policies.md) section for reference.



Back to [Features](./features.md)

Back to [Design Specification](../design.md)

