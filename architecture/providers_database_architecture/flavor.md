# Flavor model documentation

List available flavors and get details for a specified flavor. A flavor is a hardware configuration for a server. Each flavor is a unique combination of disk space and memory capacity.

* Table: flavors
* Used in: OpenStack, Amazon
* STI models: FlavorAmazon FlavorOpenstack

| Column                   | Type      | Used in           | Comment |
| ------------------------ | --------- | ----------------- | ------- |
| ems_id                   | integer   | OpenStack, Amazon |         |
| name                     | string    | OpenStack, Amazon | Name of the new flavor |
| description              | string    | OpenStack, Amazon | Description of the flavor |
| cpus                     | integer   | OpenStack, Amazon | Number of vcpus |
| cpu_cores                | integer   |            Amazon |         |
| memory                   | integer   | OpenStack, Amazon | Memory size in MB |
| ems_ref                  | string    | OpenStack, Amazon |         |
| type                     | string    | OpenStack, Amazon | STI class |
| supports_32_bit          | boolean   |            Amazon |         |
| supports_64_bit          | boolean   |            Amazon |         |
| enabled                  | boolean   | OpenStack, Amazon |         |
| supports_hvm             | boolean   |            Amazon |         |
| supports_paravirtual     | boolean   |            Amazon |         |
| block_storage_based_only | boolean   |            Amazon |         |
