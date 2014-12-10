# SecurityGroup model documentation

* Table: security_groups
* Used in: Amazon, OpenStack
* STI models: SecurityGroupAmazon, SecurityGroupOpenStack

| Column                 | Type      | Used in           | Comment |
| ---------------------- | --------- | ----------------- | ------- |
| name                   | string    | Amazon, OpenStack | The name of the resource |
| description            | string    | Amazon, OpenStack | The description of the resource |
| type                   | string    | Amazon, OpenStack | STI class |
| ems_id                 | integer   | Amazon, OpenStack |         |
| ems_ref                | string    | Amazon, OpenStack |         |
| cloud_network_id       | integer   | OpenStack         | ForeignKey |
| cloud_tenant_id        | integer   | OpenStack         | ForeignKey |
| orchestration_stack_id | integer   | OpenStack         | ForeignKey |
