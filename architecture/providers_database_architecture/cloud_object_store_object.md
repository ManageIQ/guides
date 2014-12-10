# CloudObjectStoreObject model documentation

Stores data content, such as documents, images, and so on. You can also store custom metadata with an object.

Store an unlimited number of objects. Each object can be as large as 5 GB, which is the default. You can configure the maximum object size.


* Table: cloud_object_store_objects
* Used in: OpenStack

| Column                          | Type      | Used in   | Comment |
| ------------------------------- | --------- | --------- | ------- |
| ems_ref                         | string    | OpenStack |         |
| etag                            | string    | OpenStack | For objects smaller than 5 GB, this value is the MD5 checksum of the object content. The value is not quoted. <br> For manifest objects, this value is the MD5 checksum of the concatenated string of MD5 checksums and ETags for each of the segments in the manifest, and not the MD5 checksum of the content that was downloaded. Also the value is enclosed in double-quote characters. <br> You are strongly recommended to compute the MD5 checksum of the response body as it is received and compare this value with the one in the ETag header. If they differ, the content was corrupted, so retry the operation. |
| key                             | string    | OpenStack |         |
| content_type                    | string    | OpenStack | The MIME type of the object. |
| content_length                  | integer   | OpenStack | The length of the object content in the response body, in bytes. |
| last_modified                   | datetime  | OpenStack | The date and time that the object was created or the last time that the metadata was changed. |
| ems_id                          | integer   | OpenStack |         |
| cloud_tenant_id                 | integer   | OpenStack | ForeignKey |
| cloud_object_store_container_id | integer   | OpenStack | ForeignKey |
