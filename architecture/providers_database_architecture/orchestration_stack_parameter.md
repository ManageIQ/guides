# OrchestrationStackParameter model documentation

* Table: orchestration_stack_parameters
* Used in: OpenStack

| Column    | Type      | Used in           | Comment |
| --------- | --------- | ----------------- | ------- |
| name      | string    | OpenStack         | The name of the parameter |
| value     | text      | OpenStack         | The value of the parameter |
| stack_id  | integer   | OpenStack         | ForeignKey |
