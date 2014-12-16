# CloudResourceQuota model documentation

To prevent system capacities from being exhausted without notification, you can set up quotas. Quotas are operational limits. For example, the number of gigabytes allowed for each tenant can be controlled so that cloud resources are optimized. Quotas can be enforced at both the tenant (or project) and the tenant-user level.

For OpenStack, list of available quotas can be found here http://docs.openstack.org/user-guide-admin/content/cli_set_quotas.html
Using the command-line interface, you can manage quotas for the OpenStack Compute service, the OpenStack Block Storage service, and the OpenStack Networking service.

* Table: cloud_resource_quotas
* Used in: OpenStack
* STI models: CloudResourceQuotaOpenstack

| Column          | Type      | Used in   | Comment |
| ----------------| --------- | --------- | ------- |
| ems_ref         | string    | OpenStack |         |
| service_name    | string    | OpenStack | Name of the service (e.g. Compute) |
| name            | string    | OpenStack | Name of the quota |
| value           | integer   | OpenStack | Value of the quota |
| type            | string    | OpenStack | STI class |
| ems_id          | integer   | OpenStack |         |
| cloud_tenant_id | integer   | OpenStack | ForeignKey |
| created_at      | datetime  | OpenStack |         |
| updated_at      | datetime  | OpenStack |         |
