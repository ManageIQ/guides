# OrchestrationStackResource model documentation

* Table: orchestration_stack_resources
* Used in: OpenStack

| Column                 | Type      | Used in           | Comment |
| ---------------------- | --------- | ----------------- | ------- |
| name                   | string    | OpenStack         | The name of the resource |
| description            | text      | OpenStack         | The description of the resource |
| logical_resource       | text      | OpenStack         | The same as the name |
| physical_resource      | text      | OpenStack         | The unique UUID of the resource. <br> For some special types it acts as foreign key, e.g. for OS::Nova::Server, it's the UUID of nova server. |
| resource_category      | string    | OpenStack         | The type of the resource |
| resource_status        | string    | OpenStack         | The status of the resource |
| resource_status_reason | text      | OpenStack         | The reason of the status, usually error message. |
| last_updated           | datetime  | OpenStack         | |
| stack_id               | integer   | OpenStack         | ForeignKey |
