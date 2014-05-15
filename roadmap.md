# Roadmap

## General Code Improvements

* Improve Test Coverage
* Improve Test Performance
* Improve Code via CodeClimate
  * Deduplication

## Code Extraction

* All the directories in the high-level lib directory should be extracted to ruby gems
* When REST API is mature and capable enough
  * Automation Engine should be extracted into separate Rails Engine project
  * UI (most controllers and views) should be extracted into separate Rails Engine project

## Refactor

* Job should belong_to Task and UI should ONLY show Task Progress
* VmOrTemplate and Host should be changed to has_one ComputerSystem
  * common attributes should be extracted from Host and VmOrTemplate models
  * should be fleece-able
  * should be report-able
  * should support policy enforcement on  

## Logging

* Log messages should be categorized and numbered
* Log levels should be settable by category (eg database, communication, vmware, events)

## Cloud Providers

* OpenStack
  * support Heat
  * Events via Ceilometer
* Amazon AWS
  * support CloudFormations
* Microsoft Azure
  * no support yet

## Virtual Infrastructure Providers

* VMware
* oVirt / RHEV
* Microsoft SCVMM

## Storage Providers

* NetApp
  * should be reviewed / re-tested
* Gluster
* Hitachi
* EMC

## General Features

* Zone-based Memcache Daemon
* MiqQueue should transition to industry standard message bus
* Use Ruby 2.x (currently using Ruby 1.9.3)
* Use Rails 4.x (currently using Rails 3.2)
* Use PostgreSQL Clustering for SQL High Availability and Failover
* Configuration Settings should be specified and enforced at Region/Zone/Appliance/Worker levels (currently at the Appliance Level only)
* Database Introspection
  * should be reviewed / re-tested
* System should be introspective
  * should monitor activity
  * should make recommendations
    * add/remove appliance
    * add/remove worker
    * add/remove role
  * should present information in GUI
  * should present information in log periodically

# License

![Creative Commons License](http://i.creativecommons.org/l/by/3.0/88x31.png)
This work is licensed under a [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/deed.en_US)
