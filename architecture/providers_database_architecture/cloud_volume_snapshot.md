# CloudVolumeSnapshot model documentation

A snapshot is a point in time copy of the data that a volume contains.

* Table: cloud_volume_snapshots
* Used in: OpenStack, Amazon
* STI models: CloudVolumeSnapshotAmazon, CloudVolumeSnapshotOpenstack

| Column          | Type      | Used in           | Comment |
| --------------- | --------- | ----------------- | ------- |
| type            | string    | OpenStack, Amazon | STI class |
| ems_ref         | string    | OpenStack, Amazon |         |
| ems_id          | integer   | OpenStack, Amazon |         |
| cloud_volume_id | integer   | OpenStack, Amazon | ForeignKey |
| name            | string    | OpenStack, Amazon | Name of the snapshot. Default==None. |
| description     | string    | OpenStack, Amazon | Description of snapshot. Default==None. |
| status          | string    | OpenStack, Amazon | Snapshot status |
| creation_time   | datetime  | OpenStack, Amazon | Date and time when the snapshot was created |
| size            | integer   | OpenStack, Amazon | The size of the volume, in GBs. |
| cloud_tenant_id | integer   | OpenStack, Amazon | ForeignKey |
