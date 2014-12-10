# CloudObjectStoreContainer model documentation

Defines a namespace for objects. An object with the same name in two different containers represents two different objects. You can create any number of containers within an account.

In addition to containing objects, you can also use the container to control access to objects by using an access control list (ACL). You cannot store an ACL with individual objects.

In addition, you configure and control many other features, such as object versioning, at the container level

You can bulk-delete up to 10,000 containers in a single request

* Table: cloud_object_store_containers
* Used in: OpenStack

| Column          | Type      | Used in   | Comment |
| --------------- | --------- | --------- | ------- |
| ems_ref         | string    | OpenStack |         |
| key             | string    | OpenStack |         |
| object_count    | integer   | OpenStack | Number of the all objects inside of the container |
| bytes           | integer   | OpenStack | Size of the whole container in bytes |
| ems_id          | integer   | OpenStack |         |
| cloud_tenant_id | integer   | OpenStack | ForeignKey |
