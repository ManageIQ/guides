# CloudSubnet model documentation

A subnet represents an IP address block that can be used for assigning IP addresses to virtual instances. Each subnet must have a CIDR and must be associated with a network. IPs can be either selected from the whole subnet CIDR, or from "allocation pools" that can be specified by the user.

A subnet can also optionally have a gateway, a list of DNS name servers, and host routes. All this information will then be pushed to instances whose interfaces are associated with the subnet.

* Table: cloud_subnets
* Used in: OpenStack

| Column               | Type      | Used in   | Comment |
| -------------------- | --------- | --------- | ------- |
| name                 | string    | OpenStack |         |
| ems_ref              | string    | OpenStack |         |
| ems_id               | integer   | OpenStack |         |
| availability_zone_id | integer   | OpenStack | ForeignKey |
| cloud_network_id     | integer   | OpenStack | ForeignKey |
| cidr                 | string    | OpenStack | Valid CIDR in the form <network_address>/<prefix> |
| status               | string    | OpenStack |         |
| dhcp_enabled         | boolean   | OpenStack | { true or false } |
| gateway              | string    | OpenStack | Valid IP address or null |
| network_protocol     | string    | OpenStack | IP version { ipv4 or ipv6 } |
