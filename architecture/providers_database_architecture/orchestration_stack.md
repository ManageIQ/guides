# OrchestrationStack model documentation

* Table: orchestration_stacks
* Used in: OpenStack

| Column                    | Type      | Used in           | Comment |
| ------------------------- | --------- | ----------------- | ------- |
| name                      | string    | OpenStack         | The name of the stack |
| type                      | string    | OpenStack         | STI class |
| description               | text      | OpenStack         | The description of the stack |
| status                    | string    | OpenStack         | Status of the stack |
| ems_ref                   | string    | OpenStack         |         |
| ancestry                  | string    | OpenStack         |         |
| ems_id                    | integer   | OpenStack         |         |
| orchestration_template_id | integer   | OpenStack         | ForeignKey |
| created_at                | datetime  | OpenStack         |         |
| updated_at                | datetime  | OpenStack         |         |
