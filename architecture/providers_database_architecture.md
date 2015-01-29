# Providers database architecture

All the providers are using the same model of the database on the
background. This documentation describes each model, database
structure with description of each field and ER-Diagram of each
group, to show the relations of the models.

## Inventory Models

When creating new provider, these will be the models that should
be filled with EMS_Refresh.

* Cloud
  * [CloudNetwork](providers_database_architecture/cloud_network.md)
  * [CloudSubnet](providers_database_architecture/cloud_subnet.md)
  * [CloudObjectStoreContainer](providers_database_architecture/cloud_object_store_container.md)
  * [CloudObjectStoreObject](providers_database_architecture/cloud_object_store_object.md)
  * [CloudResourceQuota](providers_database_architecture/cloud_resource_quota.md) (STI)
    * CloudResourceQuotaOpenstack
  * [CloudTenant](providers_database_architecture/cloud_tenant.md) (STI)
    * CloudTenantOpenstack
  * [CloudVolume](providers_database_architecture/cloud_volume.md) (STI)
    * CloudVolumeAmazon
    * CloudVolumeOpenstack
  * [CloudVolumeSnapshot](providers_database_architecture/cloud_volume_snapshot.md) (STI)
    * CloudVolumeSnapshotAmazon
    * CloudVolumeSnapshotOpenstack
* [VmOrTemplate](providers_database_architecture/vm_or_template.md) (STI)
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
* Orchestration
  * [OrchestrationStack](providers_database_architecture/orchestration_stack.md)
  * [OrchestrationStackOutput](providers_database_architecture/orchestration_stack_output.md)
  * [OrchestrationStackParameter](providers_database_architecture/orchestration_stack_parameter.md)
  * [OrchestrationStackResource](providers_database_architecture/orchestration_stack_resource.md)
  * [OrchestrationTemplate](providers_database_architecture/orchestration_template.md)
* [Host](providers_database_architecture/host.md) (STI)
  * HostOpenstackInfra
  * HostKvm
  * HostMicrosoft
  * HostRedhat
  * HostVmware
    * HostVmwareEsx
* [Hardware](providers_database_architecture/hardware.md)
* [AvailabilityZone](providers_database_architecture/availability_zone.md) (STI)
  * AvailabilityZoneAmazon
  * AvailabilityZoneOpenstack
    * AvailabilityZoneOpenstackNull
* [Flavor](providers_database_architecture/flavor.md) (STI)
  * FlavorAmazon
  * FlavorOpenstack
* [SecurityGroup](providers_database_architecture/security_group.md) (STI)
  * SecurityGroupAmazon
  * SecurityGroupOpenstack

## Metric Models

* [Metric](providers_database_architecture/metric.md)

## Event Models
