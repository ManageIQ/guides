# Architecture

* [Source Code Layout](architecture/source_code_layout.md)
* [Enterprise Architecture](architecture/enterprise.md)
* [Providers and Workers](architecture/providers_overview.md)

## Appliance Contents

* Apache
* Thin
* PostgreSQL
* Memcached
* Console

## Server Roles

* Generic and Priority Workers
* User Interface
* Web Services
  * SOAP
  * REST
* Provider
  * Event Catcher/Handler
  * EMS Refresh
  * EMS Metrics
  * EMS Operations
* SmartState Analysis (Fleecing)
* Automate
* Reporting
* Scheduling
* Notifier
* Database
  * DB Synchronization (Replication)
  * DB Owner
  * DB Operations
* Storage
  * Storage Inventory
  * Storage Metrics
  * Storage Bridge

## Insight/Control/Automate

## UI Layout

* Cloud Intelligence
  * Dashboard
  * Reports
  * Chargeback
  * Timelines
  * RSS
* Services
  * My Services
  * Catalogs
  * Workloads
  * Requests
* Clouds
  * Providers
  * Availability Zones
  * Flavors
  * Security Groups
  * Instances
* Infrastructure
  * Providers
  * Clusters
  * Hosts
  * Virtual Machines
  * Resource Pools
  * Datastores
  * Repositories
  * PXE
  * Requests
* Storage
  * Filers
  * Volumes
  * LUNs
  * File Shares
  * Storage Managers
* Control
  * Explorer
  * Simulation
  * Import/Export
  * Log
* Automate
  * Explorer
  * Simulation
  * Customization
  * Import/Export
  * Log
  * Requests
* Optimize
  * Utilization
  * Planning
  * Bottlenecks
* Configure
  * My Settings
  * Tasks
  * Configuration
  * SmartProxies
  * About

## Database Architecture

[Detailed Providers database architecture](architecture/providers_database_architecture.md)

* Schema Layout
  * 64-bit ids
* MiqQueue
* MiqTask and Job
* ExtManagementSystem and subclasses
* VmOrTemplate and subclasses
* Host and subclasses
