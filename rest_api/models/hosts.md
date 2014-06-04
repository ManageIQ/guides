
### Hosts

Hosts are computer systems on which virtual machines provider software runs on, i.e. VmWare vCenter or RHEV. 

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/hosts/5",
  "name": "testhost.local.com",
  "hostname": "testhost.local.com",
  "ipaddress": "192.168.1.5",
  "admin_disabled": false,
  "asset_tag": "unknown",
  "connection_state": "connected",
  "created_on": "2013-11-19T00:31:30Z",
  "ems_cluster_id": 3,
  "ems_id": 2,
  "ems_ref": "host-test",
  "ems_ref_obj": "host-test",
  "guid": "ef8ec3ae-50b1-11e3-8dc1-b8e85646e742",
  "hyperthreading": false,
  "power_state": "on",
  "service_tag": "FC64KN1",
  "settings": {
    "autoscan": false,
    "inherit_mgt_tags": false,
    "scan_frequency": 0
  },
  "smart": 1,
  "uid_ems": "testhost.local.com",
  "updated_on": "2013-12-10T19:34:52Z",
  "vmm_buildnumber": "348481",
  "vmm_product": "ESXi",
  "vmm_vendor": "VMware",
  "vmm_version": "4.1.0"
  }
  "actions": [
    {"name": "edit", "method": "post", "href": "http://localhost:3000/api/hosts/5"},
    {"name": "refresh", "method": "post", "href": "http://localhost:3000/api/hosts/5"},
    {"name": "standby", "method": "post", "href": "http://localhost:3000/api/hosts/5"},
    {"name": "shutdown", "method": "post", "href": "http://localhost:3000/api/hosts/5"},
    {"name": "restart", "method": "post", "href": "http://localhost:3000/api/hosts/5"},
    {"name": "poweron", "method": "post", "href": "http://localhost:3000/api/hosts/5"},
    {"name": "poweroff", "method": "post", "href": "http://localhost:3000/api/hosts/5"},
    {"name": "reset", "method": "post", "href": "http://localhost:3000/api/hosts/5"},
    {"name": "delete", "method": "delete", "href": "http://localhost:3000/api/hosts/5"}
  ]
}
```

#### Sub Collections

* tags
* policies

#### Attributes

`Required`

```
name, hostname, ipaddress, userid, password
```

`Optional`

```
auth_type=remote|ws|ipmi
```

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new Host |
| edit | Edit a Host |
| refresh | Refresh Relationships and Power States |
| standby | Enter Standby Mode |
| shutdown | Shuwdown a Host | 
| restart | Restart a Host | 
| poweron | Power On a Host | 
| poweroff | Power Off a Host |
| reset | Reset a Host |
| delete | Remove one or more Hosts from the VMDB |

##### Add

`POST /api/hosts`

```json
{
  "action": "add",
  "resource": {
     "name" : "temphost",
     "hostname" : "temphost.local.com",
     "ipaddress" : "192.168.4.5",
     "userid" : "root",
     "password" : "test123",
  }
}
```

#### Restart

Restart multiple hosts

`POST /api/hosts`

```json
{
  "action" : "restart"
  "resources" : [
      { "href" : "http://localhost:3000/api/hosts/14" },
      { "href" : "http://localhost:3000/api/hosts/15" }
  ]
}
```

#### PowerOff

Power Off a single hosts

`POST /api/hosts/20`

```json
{
  "action" : "restart"
}
```

#### Delete

Delete a single existing host

`DELETE /api/hosts/1`

Delete multiple hosts

`POST /api/hosts`

```json
{
  "action" : "delete"
  "resources" : [
      { "href" : "http://localhost:3000/api/hosts/1" },
      { "href" : "http://localhost:3000/api/hosts/2" }
  ]
}
```


#### Tags

Tags on a Host can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.

#### Policies

Policies on a Host can be accessed as a subcollection. Please refer to the [Policies in a Resource](./policies.md) section for reference.


Back to [Features](./features.md)

Back to [Design Specification](../design.md)

