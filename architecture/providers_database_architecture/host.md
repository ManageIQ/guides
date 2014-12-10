# Host model documentation

* Table: hosts
* Used in: Kvm, Microsoft, Redhat, Vmware
* STI models:
  * HostKvm
  * HostMicrosoft
  * HostRedhat
  * HostVmware
    * HostVmwareEsx

| Column                  | Type      | Used in           | Comment |
| ----------------------- | --------- | ----------------- | ------- |
| name                    | string    |                   |         |
| hostname                | string    |                   |         |
| ipaddress               | string    |                   |         |
| vmm_vendor              | string    |                   |         |
| vmm_version             | string    |                   |         |
| vmm_product             | string    |                   |         |
| vmm_buildnumber         | string    |                   |         |
| created_on              | datetime  |                   |         |
| updated_on              | datetime  |                   |         |
| guid                    | string    |                   |         |
| ems_id                  | integer   |                   |         |
| user_assigned_os        | string    |                   |         |
| power_state             | string    |                   |         |
| smart                   | integer   |                   |         |
| settings                | string    |                   |         |
| last_perf_capture_on    | datetime  |                   |         |
| uid_ems                 | string    |                   |         |
| connection_state        | string    |                   |         |
| ssh_permit_root_login   | string    |                   |         |
| ems_ref_obj             | string    |                   |         |
| admin_disabled          | boolean   |                   |         |
| service_tag             | string    |                   |         |
| asset_tag               | string    |                   |         |
| ipmi_address            | string    |                   |         |
| mac_address             | string    |                   |         |
| type                    | string    |                   | STI class |
| failover                | boolean   |                   |         |
| ems_ref                 | string    |                   |         |
| hyperthreading          | boolean   |                   |         |
| ems_cluster_id          | integer   |                   | ForeignKey |
| next_available_vnc_port | integer   |                   |         |
