# OrchestrationTemplate model documentation

* Table: orchestration_stack_resources
* Used in: OpenStack

| Column      | Type      | Used in           | Comment |
| ----------- | --------- | ----------------- | ------- |
| name        | string    | OpenStack         | The name of the resource |
| type        | string    | OpenStack         | STI class |
| description | text      | OpenStack         | The description of the resource |
| content     | text      | OpenStack         | Template content in YAML format |
| ems_ref     | string    | OpenStack         |         |
| created_at  | datetime  | OpenStack         |         |
| updated_at  | datetime  | OpenStack         |         |
