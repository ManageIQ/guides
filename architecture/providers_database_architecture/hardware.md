# Hardware model documentation

* Table: hosts
* Used in: Kvm, Microsoft, Redhat, Vmware, OpenstackInfra

| Column                  | Type      | Used in           | Comment |
| ----------------------- | --------- | ----------------- | ------- |
| config_version          | string    |                   |         |
| virtual_hw_version      | string    |                   |         |
| guest_os                | string    |                   |         |
| numvcpus                | integer   | OpenstackInfra    | Physical CPU count |
| bios                    | string    |                   |         |
| bios_location           | string    |                   |         |
| time_sync               | string    |                   |         |
| annotation              | text      |                   |         |
| vm_or_template_id       | integer   | All               | ForeignKey |
| memory_cpu              | integer   | OpenstackInfra    | Total memory (Mb) |
| host_id                 | integer   | All               | ForeignKey        |
| cpu_speed               | integer   |                   | Processor speed |
| cpu_type                | string    |                   | Usually string of 'cpu_manufacturer', 'cpu_model' and 'cpu_family' |
| size_on_disk            | integer   |                   |         |
| manufacturer            | string    |                   | CPU manufacturer |
| model                   | string    |                   | CPU model |
| number_of_nics          | integer   |                   |         |
| cpu_usage               | integer   |                   |         |
| memory_usage            | integer   |                   |         |
| cores_per_socket        | integer   |                   | Cores per CPU |
| logical_cpus            | integer   |                   | Logical processor count |
| vmotion_enabled         | boolean   |                   |         |
| disk_free_space         | integer   |                   |         |
| disk_capacity           | integer   | OpenstackInfra    | Capacity of the disk (Gb) |
| guest_os_full_name      | string    |                   |         |
| memory_console          | integer   |                   |         |
| bitness                 | integer   |                   |         |
| virtualization_type     | string    |                   |         |
| root_device_type        | string    |                   |         |
