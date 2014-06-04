
### Zones

Appliance Zones are used to isolate traffic. A Management System discovered by an EVM
Appliance in a specific zone gets monitored and managed in that zone.  All jobs,
such as a SmartState Analysis or VM start, dispatched by an EVM Appliance in a
specific EVM Zone can get processed by any EVM Appliance assigned to that same
zone.

Zones can be created based on your own environment.  You can make zones based on
geographic location, network location, or function.  When first started, a new
EVM Server is put into the default zone.

```json
{
  "id": "http://localhost:3000/api/zones/1",
  "name": "west_coast",
  "description" : "West Coast Zone",
  "created_on" : "2012-08-02T18:20:07Z",
  "updated_on" : "2012-08-02T18:20:07Z",
  "settings": {
    "proxy_server_ip" : "192.168.177.128",
    "concurrent_vm_scans" : 10,
    "ntp": {
      "server" : [
        "pool.ntp.org"
      ]
    }
  },
  "servers" : {
    "count" : "2",
    "resources" : [
      { "href" : "http://localhost:3000/api/servers/1" },
      { "href" : "http://localhost:3000/api/servers/2" }
    ]
  },
  "actions" : [
    { "name" : "edit", "method" : "post", "href" : "http://localhost:3000/api/zones/1" },
    { "name" : "delete", "method" : "delete", "href" : "http://localhost:3000/api/zones/1" }
  ]
}
```

#### Attributes

`Required`

```
name, description
```

`Optional`

```
settings
```

#### Actions

| Name | Description |
|------|-------------|
| add | Add a new Zone |
| edit | Edit a Zone |
| delete | Delete one or more Zones |

##### Add

Zones can be created based on your own environment. You can make zones based on
geographic location, network location, or function. When first started, a new
EVM Server is put into the default zone.

`POST /api/zones`

```json
{
  "action": "add",
  "resources" : [
    {
      "name" : "east_coast",
      "description" : "East Coast Zone",
      "settings": {
        "proxy_server_ip" : "192.168.187.128",
      }
    }
  ]
}
```

##### Edit

`POST /api/zones/1`

```json
{
  "action": "edit",
  "resource" : {
    "settings" : {
      "proxy_server_ip" : "192.168.197.128",
    }
  }
}
```

##### Delete

Delete the zone from the Zone collection. You might delete multiple zones at once.

`POST /api/zones`

```json
{
  "action": "delete",
  "resources" : [
    { "href" : "http://localhost:3000/api/zones/1" },
    { "href" : "http://localhost:3000/api/zones/2" }
  ]
}
```


Back to [Features](./features.md)

Back to [Design Specification](../design.md)
