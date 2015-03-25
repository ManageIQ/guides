## Provider Overview

### What's a Provider?

`Provider == ExtManagementSystem`

In [ManageIQ](https://github.com/ManageIQ/manageiq), providers are "external management systems".  To be fair, this is a legacy description and will be [changing over time](https://github.com/ManageIQ/manageiq/issues/1272).  However, for this documentation, the legacy description will suffice.

From a simple point of view, an [ExtManagementSystem](https://github.com/ManageIQ/manageiq/blob/08e4424951a6d229bc7c55a412dbb5f9befd7e7e/vmdb/app/models/ext_management_system.rb) is a model object representing the details of connecting to and interacting with a provider.

Conceptually, a provider is any system that ManageIQ integrates with for the purpose of collecting data and performing operations.

An example of a provider is OpenStack Cloud, known in ManageIQ as [EmsOpenstack](https://github.com/ManageIQ/manageiq/blob/e4cdcfcf46b93794bd4b6cd0f0e3e0b53d1568c6/vmdb/app/models/ems_openstack.rb).

### Inventory

Every provider has an associated inventory.  One of the main goals with adding a provider to ManageIQ is to collect the inventory of the provider.  Some examples of inventory objects are:

* [VMs](https://github.com/ManageIQ/manageiq/blob/4f557f06ac78756e5b6e4e876f8e103932e4d65a/vmdb/app/models/vm.rb)
* [Hosts](https://github.com/ManageIQ/manageiq/blob/5a8570608536ed6441a9d1ff45c8e23f286e64d7/vmdb/app/models/host.rb)
* [Containers](https://github.com/ManageIQ/manageiq/blob/bfdf9c5e05ce8b00a75bcb2b62f1e627d954ae6b/vmdb/app/models/container.rb)

### Workers

As a model object, ExtManagementSystem is relatively mundane.  It defines some operations that can be executed against its various inventory objects.  Various workers are used to capture inventory, events, and metrics for providers.

#### Worker Layout

Workers are broken down into three different pieces:

1. Model class: [app/models/miq_worker.rb](https://github.com/ManageIQ/manageiq/blob/0ca567d46b850f14129a3866619a26040bb75752/vmdb/app/models/miq_worker.rb)
2. Worker class: [lib/workers/worker_base.rb](https://github.com/ManageIQ/manageiq/blob/b1ed1c3799ccf7d03aeeda887d9f3e40c2b4367d/vmdb/lib/workers/queue_worker_base.rb)
3. Executable: [lib/workers/bin/worker.rb](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/lib/workers/bin/worker.rb)

Workers are all separate processes started and managed by the [main server](https://github.com/ManageIQ/guides/blob/master/architecture/enterprise.md#appliance).  Worker processes are tracked in the `miq_workers` table as instances of the `MiqWorker` model object.  These records are used by the main server to track the actual worker processes.

An instance of `WorkerBase` is where the actual work happens.  Each `WorkerBase` instance can indentify the `MiqWorker` record and the `MiqWorker` instance can identify its corresponding `WorkerBase` class.

Each worker has subclasses that implement specific worker functionality, such as Refresh Workers, Event Catcher Workers, and Metrics Collector Workers.

In many cases, workers are further subclassed by provider to implement provider-specific functionality.

#### Worker Types

##### Refresh Worker

* Model Class: [MiqEmsRefreshWorker](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/app/models/miq_ems_refresh_worker.rb)
* Worker Class: [EmsRefreshWorker](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/lib/workers/ems_refresh_worker.rb)

The Refresh Worker is a queue-based worker.  This means that the worker responds to specific messages that appear on the [worker queue](https://github.com/ManageIQ/manageiq/blob/98bf676b79f51003ca0404e51d92a8d72bc555d9/vmdb/app/models/miq_queue.rb).  Other processes will enqueue a message requesting a refresh of a particular provider.

The Refresh Worker responds to the request to refresh a provider's inventory.  These requests can come from several different places:

1. Refreshes are triggered for all registered providers when the appliance starts
2. Users can initiate a refresh from the Web UI
3. Events received from the provider can trigger a refresh
4. Refreshes are scheduled to occur once every 24 hours, for all providers, by default

When a refresh request is received by a Refresh Worker, the worker uses the [`EmsRefresh`](https://github.com/ManageIQ/manageiq/blob/a6175c6d5e3b00e87b2e883c835ac7acd6e3e224/vmdb/app/models/ems_refresh.rb) module to perform the actual refresh.  Each provider implements a refresh process.

Refresh Workers are created for each registered provider.  In other words, if you have registered two OpenStack Cloud providers, there will be two unique Openstack Refresh Worker processes running.

OpenStack Example:
* Model Class: [`MiqEmsRefreshWorkerOpenstack`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/app/models/miq_ems_refresh_worker_openstack.rb)
* Worker Class: [`EmsRefreshWorkerOpenstack`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/lib/workers/ems_refresh_worker_openstack.rb)

##### Event Catcher Worker

* Model Class: [`MiqEventCatcher`](https://github.com/ManageIQ/manageiq/blob/e18c49a777beb0ee7e81d24cd00803f5be786bcb/vmdb/app/models/miq_event_catcher.rb)
* Worker Class: [`EventCatcher`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/lib/workers/event_catcher.rb)



OpenStack Example:
* Model Class: [`MiqEventCatcherOpenstack`](https://github.com/ManageIQ/manageiq/blob/e18c49a777beb0ee7e81d24cd00803f5be786bcb/vmdb/app/models/miq_event_catcher.rb)
* Worker Class: [`EventCatcherOpenstack`](https://github.com/ManageIQ/manageiq/blob/e18c49a777beb0ee7e81d24cd00803f5be786bcb/vmdb/app/models/miq_event_catcher.rb)

##### Event Handler Worker

* Model Class: [`MiqEventHandler`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/app/models/miq_event_handler.rb)
* Worker Class: [`EventHandler`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/lib/workers/event_handler.rb)

##### Metrics Collector Worker

* Model Class: [`MiqEmsMetricsCollectorWorker`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/app/models/miq_ems_metrics_collector_worker.rb)
* Worker Class: [`EmsMetricsCollectorWorker`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/lib/workers/ems_metrics_collector_worker.rb)

OpenStack Example:
* Model Class: [`MiqEmsMetricsCollectorWorkerOpenstack`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/app/models/miq_ems_metrics_collector_worker_openstack.rb)
* Worker Class: [`EmsMetricsCollectorWorkerOpenstack`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/lib/workers/ems_metrics_collector_worker_openstack.rb)

##### Metrics Processor Worker

* Model Class: [`MiqEmsMetricsProcessorWorker`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/app/models/miq_ems_metrics_processor_worker.rb)
* Worker Class: [`EmsMetricsProcessorWorker`](https://github.com/ManageIQ/manageiq/blob/d34d87219092431c22c88a5865f25f9942ebe1ea/vmdb/lib/workers/ems_metrics_processor_worker.rb)
