## Trigger multiple Provision Requests

*In the provision requests*:

- version defaults to "1.1" if not specified.
- user_name defaults to the REST API authenticated user if not specified.

```
POST /api/provision_requests
```

```json
{
  "action" : "create",
  "resources" : [
    {
      "version" : "1.1",
      "template_fields" : { "guid" : "afe6e8a0-89fd-11e3-b6ac-b8e85646e742" },
      "vm_fields" : { "vm_name" : "jdoe_rest_vm1",
                      "number_of_cpus" : 1,
                      "vm_memory" : "1024",
                      "vlan" : "nic1" },
      "requester" : { "user_name" : "jdoe",
                      "owner_first_name" : "John", 
                      "owner_last_name" : "Doe",
                      "owner_email" : "jdoe@sample.com",
                      "auto_approve" : true },
      "tags" : {      "network_location" : "Internal",
                      "cc" : "001" },
      "additional_values" : { "request_id" : "1001" },
      "ems_custom_attributes" : { },
      "miq_custom_attributes" : { }
    },
    {
      "template_fields" : { "guid" : "afe6e8a0-89fd-11e3-b6ac-b8e85646e742" },
      "vm_fields" : { "vm_name" : "jdoe_rest_vm2",
                      "number_of_cpus" : 1,
                      "vm_memory" : "2048",
                      "vlan" : "nic1" },
      "requester" : { "owner_first_name" : "John", 
                      "owner_last_name" : "Doe",
                      "owner_email" : "jdoe@sample.com",
                      "auto_approve" : true },
      "tags" : {      "network_location" : "Internal",
                      "cc" : "001" },
      "additional_values" : { "request_id" : "1002" }
    },
    {
      "template_fields" : { "guid" : "afe6e8a0-89fd-11e3-b6ac-b8e85646e742" },
      "vm_fields" : { "vm_name" : "jdoe_rest_vm3",
                      "number_of_cpus" : 1,
                      "vm_memory" : "4096",
                      "vlan" : "nic1" },
      "requester" : { "owner_first_name" : "John",
                      "owner_last_name" : "Doe",
                      "owner_email" : "jdoe@sample.com",
                      "auto_approve" : true },
      "tags" : {      "network_location" : "Internal",
                      "cc" : "001" },
      "additional_values" : { "request_id" : "1003" }
    },
    {
      "template_fields" : { "guid" : "afe6e8a0-89fd-11e3-b6ac-b8e85646e742" },
      "vm_fields" : { "vm_name" : "jdoe_rest_vm4",
                      "number_of_cpus" : 1,
                      "vm_memory" : "8192",
                      "vlan" : "nic1" },
      "requester" : { "owner_first_name" : "John",
                      "owner_last_name" : "Doe",
                      "owner_email" : "jdoe@sample.com",
                      "auto_approve" : true },
      "tags" : {      "network_location" : "Internal",
                      "cc" : "001" },
      "additional_values" : { "request_id" : "1004" }
    }
  ]
}
```

Back to [Reference Guide](../reference.md)
