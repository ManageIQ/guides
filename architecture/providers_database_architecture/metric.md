# Metric model documentation

Metrics for the whole ManageIQ, tracking VMs as well as baremetal.

* Table: flavors
* Used in: All

| Column                                  | Type      | Used in           | Comment |
| --------------------------------------- | --------- | ----------------- | ------- |
| "timestamp"                             | datetime  |                   |         |
| "capture_interval"                      | integer   |                   |         |
| "resource_type"                         | string    | All               | Polymorphic relation to resource |
| "resource_id",                          | integer   | All               | Polymorphic relation to resource |
| "cpu_usage_rate_average"                | float     | OpenstackInfra    | Average usage of CPU |
| "cpu_usagemhz_rate_average"             | float     |                   |         |
| "mem_usage_absolute_average"            | float     |                   |         |
| "disk_usage_rate_average"               | float     | OpenstackInfra    | Average usage of disks |
| "net_usage_rate_average"                | float     | OpenstackInfra    | Average usage of net |
| "sys_uptime_absolute_latest"            | float     |                   |         |
| "created_on"                            | datetime  | All               |         |
| "derived_cpu_available"                 | float     |                   |         |
| "derived_memory_available"              | float     |                   |         |
| "derived_memory_used"                   | float     |                   |         |
| "derived_cpu_reserved"                  | float     |                   |         |
| "derived_memory_reserved"               | float     |                   |         |
| "derived_vm_count_on"                   | integer   |                   |         |
| "derived_host_count_on"                 | integer   |                   |         |
| "derived_vm_count_off"                  | integer   |                   |         |
| "derived_host_count_off"                | integer   |                   |         |
| "derived_storage_total"                 | float     |                   |         |
| "derived_storage_free"                  | float     |                   |         |
| "capture_interval_name"                 | string    |                   |         |
| "assoc_ids"                             | text      |                   |         |
| "cpu_ready_delta_summation"             | float     |                   |         |
| "cpu_system_delta_summation"            | float     |                   |         |
| "cpu_wait_delta_summation"              | float     |                   |         |
| "resource_name"                         | string    |                   |         |
| "cpu_used_delta_summation"              | float     |                   |         |
| "tag_names"                             | text      |                   |         |
| "parent_host_id",                       | integer   | All               | ForeignKey |
| "parent_ems_cluster_id",                | integer   |                   |         |
| "parent_storage_id",                    | integer   |                   |         |
| "parent_ems_id",                        | integer   | All               |         |
| "derived_storage_vm_count_registered"   | float     |                   |         |
| "derived_storage_vm_count_unregistered" | float     |                   |         |
| "derived_storage_vm_count_unmanaged"    | float     |                   |         |
| "derived_storage_used_registered"       | float     |                   |         |
| "derived_storage_used_unregistered"     | float     |                   |         |
| "derived_storage_used_unmanaged"        | float     |                   |         |
| "derived_storage_snapshot_registered"   | float     |                   |         |
| "derived_storage_snapshot_unregistered" | float     |                   |         |
| "derived_storage_snapshot_unmanaged"    | float     |                   |         |
| "derived_storage_mem_registered"        | float     |                   |         |
| "derived_storage_mem_unregistered"      | float     |                   |         |
| "derived_storage_mem_unmanaged"         | float     |                   |         |
| "derived_storage_disk_registered"       | float     |                   |         |
| "derived_storage_disk_unregistered"     | float     |                   |         |
| "derived_storage_disk_unmanaged"        | float     |                   |         |
| "derived_storage_vm_count_managed"      | float     |                   |         |
| "derived_storage_used_managed"          | float     |                   |         |
| "derived_storage_snapshot_managed"      | float     |                   |         |
| "derived_storage_mem_managed"           | float     |                   |         |
| "derived_storage_disk_managed"          | float     |                   |         |
| "min_max"                               | text      |                   |         |
| "intervals_in_rollup"                   | integer   |                   |         |
| "mem_vmmemctl_absolute_average"         | float     |                   |         |
| "mem_vmmemctltarget_absolute_average"   | float     |                   |         |
| "mem_swapin_absolute_average"           | float     |                   |         |
| "mem_swapout_absolute_average"          | float     |                   |         |
| "mem_swapped_absolute_average"          | float     |                   |         |
| "mem_swaptarget_absolute_average"       | float     |                   |         |
| "disk_devicelatency_absolute_average"   | float     |                   |         |
| "disk_kernellatency_absolute_average"   | float     |                   |         |
| "disk_queuelatency_absolute_average"    | float     |                   |         |
| "derived_vm_used_disk_storage"          | float     |                   |         |
| "derived_vm_allocated_disk_storage"     | float     |                   |         |
| "derived_vm_numvcpus"                   | float     |                   |         |
| "time_profile_id",                      | integer   |                   |         |
