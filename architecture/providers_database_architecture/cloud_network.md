# CloudNetwork model documentation

A network is a virtual isolated layer-2 broadcast domain which is typically reserved to the tenant who created it, unless the network has been explicitly configured to be shared. Tenants can create multiple networks, until they reach the thresholds specified by per-tenant Quotas (see next chapter for more details). The network is the principal entity for the Neutron API. Ports and subnets must always be associated with a network. The following table describes the attributes of network objects. For each attribute, the CRUD column should be read as follows:

* Table: cloud_networks
* Used in: OpenStack

| Column                 | Type      | Used in   | Comment |
| ---------------------- | --------- | --------- | ------- |
| name                   | string    | OpenStack | Name of the network |
| ems_ref                | string    | OpenStack |         |
| ems_id                 | integer   | OpenStack |         |
| cidr                   | string    | OpenStack | Valid CIDR in the form <network_address>/<prefix> |
| status                 | string    | OpenStack |         |
| enabled                | boolean   | OpenStack |         |
| external_facing        | boolean   | OpenStack |         |
| cloud_tenant_id        | integer   | OpenStack | ForeignKey |
| orchestration_stack_id | integer   | OpenStack | ForeignKey |
