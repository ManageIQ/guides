## REST API Reference Guide [*v0.1*](./versioning.md)

This document presents the currently available features and capabilities of the
RESTful API. For further details on the implementation as well a complete list of the proposed
features please refer to the [Design Specification](./design.md).

### Authentication

| Type | Mechanism |
|:-----|:----------|
| Basic Authentication        | Basic HTTP Authorization with user and password |
| Token Based Authentication  | |
| - Acquiring Token           | /api/auth with Basic Authentication             |
| - Authenticating with Token | X-Auth-Token Header                             |

### HTTP Headers

| Header | Value |
|:-------|:------|
| Authorization | Basic base64_encoded(user:password) |
| X-Auth-Token  | Token provided by /api/auth         |
| Accept        | application/json                    |
| Content-Type  | application/json                    |

### Listing and Querying Collections and Sub-Collections

| Feature | Path |
|:--------|:-----|
| Listing Available Collections | /api                                          |
| Listing Collections           | /api/\<collection\>                           |
| Listing Sub-Collections       | /api/\<collection\>/\<id\>/\<sub-collection\> |

| Querying Capability  | Query Parameters |
|:---------------------|:-----------------|
| Paging               | offset, limit                                                     |
| Sorting              | sort_by=attr, sort_order=asc\|desc                                |
| Filtering            | sqlfilter="..."                                                   |
| Querying by Tag      | i.e. by_tag=/department/finance                                   |
| Expanding Results    | expand=\<what\>, i.e. expand=resources,tags,service_templates,... |
| Selecting Attributes | attributes=\<atr1\>,\<atr2\>,... i.e. attributes=id,name,type,... |

[Example Queries](./examples/queries.md)

### Collection Queries:

| Collection         | URL |
|:-------------------|:----|
| Services           | /api/services          |
| Service Templates  | /api/service_templates |
| Service Catalogs   | /api/service_catalogs  |
| Providers          | /api/providers         |
| Clusters           | /api/clusters          |
| Hosts              | /api/hosts             |
| Vms                | /api/vms               |
| Templates          | /api/templates         |
| Resource Pools     | /api/resource_pools    |
| Datastores         | /api/data_stores       |
| Policy Profiles    | /api/policy_profiles   |
| Policies           | /api/policies          |
| Zones              | /api/zones             |
| EVM Servers        | /api/servers           |
| Users              | /api/users             |
| Groups             | /api/groups            |
| Roles              | /api/roles             |
| Requests           | /api/requests          |
| Service Requests   | /api/service_requests  |

### Sub-Collection Queries

| Sub-Collection     | URL|
|:-------------------|:---|
| Service Templates  | /api/\<collection\>/\<id\>/service_templates |
| Tags               | /api/\<collection\>/\<id\>/tags              |

### Available Actions

| Action                              | Method | URL |
|:------------------------------------|:-------|:----|
| Edit Service                        | POST   | [/api/services/\<id\>](./examples/edit_service.md)           |
| Edit Service via PUT                | PUT    | [/api/services/\<id\>](./examples/edit_service_via_put.md)   |
| Edit Service via PATCH              | PATCH  | [/api/services/\<id\>](./examples/edit_service_via_patch.md) |
| Edit Service                        | POST   | [/api/services/\<id\>](./examples/edit_service.md)           |
| Edit Services                       | POST   | [/api/services/](./examples/edit_services.md)                |
| Assign Tags to Service              | POST   | [/api/services/\<id\>/tags](./examples/assign_tags.md)       |
| Unassign Tags from Service          | POST   | [/api/services/\<id\>/tags](./examples/unassign_tags.md)     |
| Retire Service (now and future)     | POST   | [/api/services/\<id\>](./examples/retire_service.md)         |
| Retire Services  (now and future)   | POST   | [/api/services](./examples/retire_services.md)               |
| Delete Service                      | DELETE | /api/services/\<id\>                                         |
| Delete Services                     | POST   | [/api/services](./examples/delete_services.md)               |
| | |
| Edit Service Template               | POST   | [/api/service_templates/\<id\>](./examples/edit_service_template.md)                       |
| Edit Service Templates              | POST   | [/api/service_templates](./examples/edit_service_templates.md)                             |
| Assign Tags to Service Template     | POST   | [/api/service_templates/\<id\>/tags](./examples/assign_tags_to_service_template.md)        |
| Unassign Tags from Service Template | POST   | [/api/service_templates/\<id\>/tags](./examples/unassign_tags_from_service_template.md)    |
| Delete Service Template             | DELETE | /api/service_templates/\<id\>                                                              |
| Delete Service Templates            | POST   | [/api/service_templates](./examples/delete_service_templates.md)                           |
| | |
| Add a new Service Catalog           | POST   | [/api/service_catalogs](./examples/add_service_catalog.md)                                 |
| Add Service Catalogs                | POST   | [/api/service_catalogs](./examples/add_service_catalogs.md)                                |
| Edit a Service Catalog              | POST   | [/api/service_catalogs/\<id\>](./examples/edit_service_catalog.md)                         |
| Edit Service Catalogs               | POST   | [/api/service_catalogs](./examples/edit_service_catalogs.md)                               |
| Assign Service Templates            | POST   | [/api/service_catalogs/\<id\>/service_templates](./examples/assign_service_templates.md)   |
| UnAssign Service Templates          | POST   | [/api/service_catalogs/\<id\>/service_templates](./examples/unassign_service_templates.md) |
| Order Service                       | POST   | [/api/service_catalogs/\<id\>/service_templates](./examples/order_service.md)              |
| Order Services                      | POST   | [/api/service_catalogs/\<id\>/service_templates](./examples/order_services.md)             |
| Delete Service Catalog              | DELETE | /api/service_catalogs/\<id\>                                        |
| Delete Service Catalogs             | POST   | [/api/service_catalogs](./examples/delete_service_catalogs.md)                             |

##### [API Version History](./versioning.md)
