# AvailabilityZone model documentation

* Table: availability_zones
* Used in: OpenStack, Amazon
* STI models:
  * AvailabilityZoneAmazon
  * AvailabilityZoneOpenstack
    * AvailabilityZoneOpenstackNull

| Column  | Type      | Used in           | Comment |
| ------- | --------- | ----------------- | ------- |
| ems_id  | integer   | OpenStack, Amazon |         |
| name    | string    | OpenStack, Amazon |         |
| ems_ref | string    | OpenStack, Amazon |         |
| type    | string    | OpenStack, Amazon | STI class |
