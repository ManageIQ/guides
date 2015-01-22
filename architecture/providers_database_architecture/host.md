# Host model documentation

OpenstackInfra host is tied to Ironic service, allowing management and
inventory collection over Ironic API.

* Table: hosts
* Used in: Kvm, Microsoft, Redhat, Vmware, OpenstackInfra
* STI models:
  * HostOpenstackInfra
  * HostKvm
  * HostMicrosoft
  * HostRedhat
  * HostVmware
    * HostVmwareEsx

| Column                  | Type      | Used in           | Comment |
| ----------------------- | --------- | ----------------- | ------- |
| name                    | string    | OpenstackInfra    | Name of the host |
| hostname                | string    |                   |         |
| ipaddress               | string    | OpenstackInfra    | IP address of the host        |
| vmm_vendor              | string    |                   |         |
| vmm_version             | string    |                   |         |
| vmm_product             | string    |                   |         |
| vmm_buildnumber         | string    |                   |         |
| created_on              | datetime  | All               | Created on timestamp of ManageIQ object |
| updated_on              | datetime  | All               | Updated on timestamp of ManageIQ object |
| guid                    | string    |                   |         |
| ems_id                  | integer   | All               | ForeignKey |
| user_assigned_os        | string    |                   |         |
| power_state             | string    | OpenstackInfra    | Power state of the host |
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
| ipmi_address            | string    | OpenstackInfra    | IP address of IPMI interface of the host |
| mac_address             | string    | OpenstackInfra    | Mac address of the host |
| type                    | string    | All               | STI class |
| failover                | boolean   |                   |         |
| ems_ref                 | string    |                   |         |
| hyperthreading          | boolean   |                   |         |
| ems_cluster_id          | integer   |                   | ForeignKey |
| next_available_vnc_port | integer   |                   |         |
