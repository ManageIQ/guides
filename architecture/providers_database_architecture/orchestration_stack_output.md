# OrchestrationStackOutput model documentation

* Table: orchestration_stack_outputs
* Used in: OpenStack

| Column       | Type      | Used in           | Comment |
| ------------ | --------- | ----------------- | ------- |
| key          | string    | OpenStack         | The key of the output |
| value        | text      | OpenStack         | The value of the output |
| description  | text      | OpenStack         | The description of the output |
| stack_id     | integer   | OpenStack         | ForeignKey |
