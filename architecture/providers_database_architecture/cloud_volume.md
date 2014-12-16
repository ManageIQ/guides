# CloudVolume model documentation

A volume is a detachable block storage device. You can think of it as a USB hard drive. You can attach a volume to one instance at a time.

* Table: cloud_volumes
* Used in: OpenStack, Amazon
* STI models: CloudVolumeAmazon, CloudVolumeOpenstack

| Column                   | Type      | Used in           | Comment |
| ------------------------ | --------- | ----------------- | ------- |
| type                     | string    | OpenStack, Amazon | STI class |
| ems_ref                  | string    | OpenStack, Amazon |         |
| size                     | integer   | OpenStack, Amazon | The size of the volume, in GBs |
| ems_id                   | integer   | OpenStack, Amazon |         |
| availability_zone_id     | integer   | OpenStack, Amazon | ForeignKey |
| cloud_volume_snapshot_id | integer   | OpenStack, Amazon | ForeignKey |
| name                     | string    | OpenStack, Amazon | The volume name |
| status                   | string    | OpenStack, Amazon | Status of the volume |
| description              | string    | OpenStack, Amazon | The volume description |
| volume_type              | string    | OpenStack, Amazon | The associated volume type |
| bootable                 | boolean   | OpenStack, Amazon | Enables or disables the bootable attribute. You can boot an instance from a bootable volume. |
| creation_time            | datetime  | OpenStack, Amazon | Date and time when the volume was created |
| cloud_tenant_id          | integer   | OpenStack, Amazon | ForeignKey |
