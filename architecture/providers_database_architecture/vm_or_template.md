# VmOrTemplate model documentation

TODO better description of model VmOrTemplate

Represents Virtual machines or Templates (Images in OpenStack terminology)

* Table: vms
* Used in: Kvm, Microsoft, Redhat, Vmware, Xen, OpenStack, Amazon
* STI models:
  * Vm
    * VmInfra
      * VmKvm
      * VmMicrosoft
      * VmRedhat
      * VmVmware
      * VmXen
    * VmCloud
      * VmAmazon
      * VmOpenstack
  * MiqTemplate
    * TemplateInfra
      * TemplateKvm
      * TemplateMicrosoft
      * TemplateRedhat
      * TemplateVmware
      * TemplateXen
    * TemplateCloud
      * TemplateAmazon
      * TemplateOpenstack

| Column                 | Type      | Used in           | Comment |
| ---------------------- | --------- | ----------------- | ------- |
| vendor                 | string    | OpenStack         |         |
| format                 | string    |                   |         |
| version                | string    |                   |         |
| name                   | string    | OpenStack         | The name of the VM |
| description            | text      |                   |         |
| location               | string    |                   |         |
| config_xml             | string    |                   |         |
| autostart              | string    |                   |         |
| host_id                | integer   |                   | ForeignKey |
| last_sync_on           | datetime  |                   |         |
| created_on             | datetime  |                   |         |
| updated_on             | datetime  |                   |         |
| storage_id             | integer   |                   | ForeignKey |
| guid                   | string    |                   |         |
| ems_id                 | integer   |                   |         |
| last_scan_on           | datetime  |                   |         |
| last_scan_attempt_on   | datetime  |                   |         |
| uid_ems                | string    |                   |         |
| retires_on             | date      |                   |         |
| retired                | boolean   |                   |         |
| boot_time              | datetime  |                   |         |
| tools_status           | string    |                   |         |
| standby_action         | string    |                   |         |
| power_state            | string    |                   |         |
| state_changed_on       | datetime  |                   |         |
| previous_state         | string    |                   |         |
| connection_state       | string    |                   |         |
| last_perf_capture_on   | datetime  |                   |         |
| blackbox_exists        | boolean   |                   |         |
| blackbox_validated     | boolean   |                   |         |
| registered             | boolean   |                   |         |
| busy                   | boolean   |                   |         |
| smart                  | boolean   |                   |         |
| memory_reserve         | integer   |                   |         |
| memory_reserve_expand  | boolean   |                   |         |
| memory_limit           | integer   |                   |         |
| memory_shares          | integer   |                   |         |
| memory_shares_level    | string    |                   |         |
| cpu_reserve            | integer   |                   |         |
| cpu_reserve_expand     | boolean   |                   |         |
| cpu_limit              | integer   |                   |         |
| cpu_shares             | integer   |                   |         |
| cpu_shares_level       | string    |                   |         |
| cpu_affinity           | string    |                   |         |
| ems_created_on         | datetime  |                   |         |
| template               | boolean   |                   |         |
| evm_owner_id           | integer   |                   | ForeignKey |
| ems_ref_obj            | string    |                   |         |
| miq_group_id           | integer   |                   | ForeignKey |
| linked_clone           | boolean   |                   |         |
| fault_tolerance        | boolean   |                   |         |
| type                   | string    |                   | STI class |
| ems_ref                | string    |                   |         |
| ems_cluster_id         | integer   |                   | ForeignKey |
| retirement_warn        | integer   |                   |         |
| retirement_last_warn   | datetime  |                   |         |
| vnc_port               | integer   |                   |         |
| flavor_id              | integer   | OpenStack, Amazon | ForeignKey |
| availability_zone_id   | integer   | OpenStack, Amazon | ForeignKey |
| cloud                  | boolean   |                   |         |
| retirement_state       | string    |                   |         |
| cloud_network_id       | integer   | OpenStack         | ForeignKey |
| cloud_subnet_id        | integer   | OpenStack         | ForeignKey |
| cloud_tenant_id        | integer   | OpenStack         | ForeignKey |
| raw_power_state        | string    |                   |         |
| publicly_available     | boolean   |                   |         |
| orchestration_stack_id | integer   | OpenStack         | ForeignKey |
