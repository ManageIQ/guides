
### Providers
*Note:* Providers are also known as External Management Systems

Providers are computers on which software, such as VMware’s vCenter, is loaded which manages
multiple Virtual Machines that reside on multiple Hosts.

#### JSON serialization

```json
{
  "id": "http://localhost:3000/api/providers/1",
  "name": "MTCVC123",
  "description" : "Openstack System",
  "type"        : "openstack",
  "hostname"    : "openstack.org.com",
  "address"     : "10.0.0.1",
  "port"        : "5000",
  "version"     : "3.0",
  "port"        : "5000",
  "cpu"         : "53000",
  "memory"      : "8192",
  "num_of_cpu"  : "4",
  "num_of_cores": "0",
  "created_on"  : "2012-08-02T18:20:07Z",
  "updated_on"  : "2012-08-02T18:20:07Z",
  "zone"        : { "href" : "http://localhost:3000/zones/1" },
  "clusters" : {
    "count" : "1",
    "resources" : [
      { "href" : "http://localhost:3000/api/clusters/1" }
    ],
  },
  "vms" : {
    "count" : "2",
    "resources" : [
      { "href" : "http://localhost:3000/api/vms/1" },
      { "href" : "http://localhost:3000/api/vms/2" }
    ]
  },
  "hosts" : {
    "count" : "1",
    "resources" : [
      { "href" : "http://localhost:3000/api/hosts/1" }
    ],
  },
  "actions" : [
    { "name" : "edit", "method" : "post", "href" : "http://localhost:3000/api/providers/1" },
    { "name" : "refresh", "method" : "post", "href" : "http://localhost:3000/api/providers/1" },
    { "name" : "delete", "method" : "delete", "href" : "http://localhost:3000/api/providers/1" }
  ]
}
```

#### Sub Collections

* tags
* policies

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new Infrastructure Provider |
| edit | Edit an Infrastructure Provider |
| refresh | Refresh Relationships and Power States |
| delete | Remove Infrastructure Provider from the VMDB |

##### Add

`POST /api/providers`

```json
{
  "action": "add",
  "resources" : [
    {
      "name"     : "NewSystem",
      "type"     : "rhevm",
      "hostname" : "rhevm.local.com",
      "address"  : "192.168.5.1",
      "port"     : "80",
      "zone"     : { "href" : "http://localhost:3000/zones/1" },
      "username" : "admin",
      "password" : "12345"
    }
  ]
}
```

##### Delete

`POST /api/providers`

```json
{
  "action": "delete",
  "resources" : [
    { "href" : "http://localhost:3000/api/providers/1" }
  ]
}
```

#### Tags

Tags on a Provider can be accessed as a subcollection. Please refer to the [Tags](./tags.md) section for reference.

#### Policies

Policies on a Provider can be accessed as a subcollection. Please refer to the [Policies in a Resource](./policies.md) section for reference.


Back to [Features](./features.md)

Back to [Design Specification](../design.md)

