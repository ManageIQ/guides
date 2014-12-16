# CloudTenant model documentation

A container used to group or isolate resources and/or identity objects. Depending on the service operator, a tenant can map to a customer, account, organization, or project.

* Table: cloud_tenants
* Used in: OpenStack
* STI models: CloudTenantOpenstack

| Column      | Type      | Used in   | Comment |
| ------------| --------- | --------- | ------- |
| name        | string    | OpenStack |         |
| description | string    | OpenStack |         |
| enabled     | boolean   | OpenStack |         |
| ems_ref     | string    | OpenStack |         |
| ems_id      | integer   | OpenStack |         |
| created_at  | datetime  | OpenStack |         |
| updated_at  | datetime  | OpenStack |         |
| type        | string    | OpenStack | STI class |
