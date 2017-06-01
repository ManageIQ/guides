## Provider Overview

### What is a Provider?

Providers are a grouping of *management systems*.

Management systems are at the center of ManageIQ's Provider Integration story.

`Manager == ExtManagementSystem`

In [ManageIQ](https://github.com/ManageIQ/manageiq), managers are the *external management systems*.  This description has changed slightly over time.  Originally, providers were external management systems.  But, this has rapidly changed as providers became more complex (like OpenStack) and less clearly defined as a manager of a single set of resources.  As providers began managing more than one type of main resource, it became clear that providers could be broken down into separate managers.

From a simple point of view, an [ExtManagementSystem](https://github.com/ManageIQ/manageiq/blob/3f41a6089380f2395057e8e100a2b4ccd2fbbc7a/app/models/ext_management_system.rb) is a model object representing the details of connecting to and interacting with a provider's manager.

Conceptually, a manager is any system that ManageIQ integrates with for the purpose of collecting data and performing operations.

An example of a manager is Amazon Cloud Manager, known in ManageIQ as [Amazon::CloudManager](https://github.com/ManageIQ/manageiq-providers-amazon/blob/master/app/models/manageiq/providers/amazon/cloud_manager.rb).

## Provider Manager Types

ManageIQ currently knows about a few different types of Provider Managers:

* Virtual Infrastructure Manager
* Cloud Manager
* Configuration Manager
* Baremetal Provisioning Manager
* [Containers Manager](../providers/containers.md)

For each type, we have at least one reference implementation:

* Virtual Infrastructure Manager :: VMWare
* Cloud Manager :: Amazon
* Configuration Manager :: Foreman (Puppet)
* Baremetal Provisioning Manager :: Foreman
* Containers Manager :: Kubernetes / OpenShift

When a new manager is being integrated, it's important to understand whether the new manager is also a new manager type.  New manager types take significantly more effort to on-board because it involves understanding what possibly new data models are required for inventory collection, as well as what possibly new event and metrics requirements will crop up.

## Provider Implementation

Integrating with a provider requires looking at six separate areas:

1. Inventory
2. Event Collection and Handling
3. Metric Collection and Handling
4. Provisioning and Orchestration
5. Lifecycle
6. SmartState Analysis

### Inventory

Every manager has an associated inventory.  One of the main goals with adding a manager to ManageIQ is to collect the inventory of the manager.  Some examples of inventory objects are:

* [VMs](https://github.com/ManageIQ/manageiq/blob/b20bb4ae37883cecb271ecf34c92d53ebf55fe45/app/models/vm.rb)
* [Hosts](https://github.com/ManageIQ/manageiq/blob/b20bb4ae37883cecb271ecf34c92d53ebf55fe45/app/models/host.rb)
* [Containers](https://github.com/ManageIQ/manageiq/blob/b20bb4ae37883cecb271ecf34c92d53ebf55fe45/app/models/container.rb)

### Events

Where inventory collection is essential for understanding what is in a manager, events are essential for understanding what is changing inside the provider over time.

Events can be used to build timelines to view a history of changes over time.  Events can also be used to react to those changes by either refreshing the manager's inventory or enforcing policies that apply to the changes witnessed in the events.

### Metrics

Metrics provide details of System Utilization for the manager's inventory objects.  For instance, in a Virtual Infrastructure Manager, utilization data can be collected for VMs, Hosts, and Clusters.  The utilization data generally comes in the form of one of the following:

* CPU utilization
* Memory utilization
* Disk reads and writes
* Network traffic

These metrics can be used to enforce policies related to capacity planning.

After the metrics are collected, different [rollup](capacity_and_utilization_collection_explanation.md#rollups) mechanisms take hold.

Rollups are especially important to understand when implementing a new manager type, because rollups for new manager types may involve infrastructure-based rollups that have not previously exist in ManageIQ.

### Provisioning and Orchestration

Provisioning refers to creating new objects in a manager's inventory.

#### Orchestration

Orchestration is somewhat like provisioning, but on a bigger scale.  It can involve provisioning multiple systems in a coordinated effort to accomplish a combined goal.

Orchestration is generally lumped in with provisioning because it tends to share several concepts.

### Lifecycle

The lifecycle of provider objects can include power operations, retirement, and reconfiguration.

#### Power Operations

Power operations are the actions that can be performed on existing objects in a manager's inventory.  Power operations are separated from provisioning to highlight that the work involved in integrating power operations is generally quite different from the work involved in integrating provisioning capabilities.

#### Retirement

Retirement is a manual or scheduled event that runs an automate state machine to decommission a manager's resource.  For instance, a user might decide to retire a cloud instance after two weeks.

#### Reconfiguration

Reconfiguration allows users to change the settings of a already-running object in a manager's inventory.  For instance, reconfiguring a cloud instance might increase the instance's memory or disk space.

### SmartState Analysis

SmartState is perhaps the most unique type of manager integration with ManageIQ.  SmartState Analysis is the process of examining and collecting details from dormant images and disks.

SmartState integration generally has one main requirement:  the appliance running SmartState Analysis needs access to the raw bytes from the images and disks that should be analyzed.  Some managers provide this via an API, while other managers provide this with NFS mounts.

## Workers

When integrating a new manager, it is important to understand two important integration points:

1. Data models that represent manager inventory
2. Workers that collect data from managers

While the data model is important, the workers are the core to the integration, since they perform all of the tasks for collecting inventory, events, and metrics.

### Worker Layout

Workers are broken down into three different pieces:

1. Model class: [app/models/miq_worker.rb](https://github.com/ManageIQ/manageiq/blob/9456ba68a455a5a0501c1e9e0aef88c78dc83338/app/models/miq_worker.rb)
2. Worker class: [lib/workers/worker_base.rb](https://github.com/ManageIQ/manageiq/blob/9456ba68a455a5a0501c1e9e0aef88c78dc83338/lib/workers/worker_base.rb)
3. Executable: [lib/workers/bin/worker.rb](https://github.com/ManageIQ/manageiq/blob/9456ba68a455a5a0501c1e9e0aef88c78dc83338/lib/workers/bin/worker.rb)

Workers are all separate processes started and managed by the [main server](enterprise.md#appliance).  Worker processes are tracked in the `miq_workers` table as instances of the `MiqWorker` model object.  These records are used by the main server to track the actual worker processes.

An instance of `WorkerBase` is where the actual work happens.  Each `WorkerBase` instance can identify the `MiqWorker` record and the `MiqWorker` instance can identify its corresponding `WorkerBase` class.

Each worker has subclasses that implement specific worker functionality, such as Refresh Workers, Event Catcher Workers, and Metrics Collector Workers.

In many cases, workers are further subclassed by manager to implement manager-specific functionality.

### Worker Types

There are three main groups of workers involved in manager integrations:

1. Refresh worker, which collects manager inventory
2. Event workers, which catch and handle events from managers
3. Metrics workers, which collect and process metrics

#### Refresh Worker

* Model Class: [BaseManager::RefreshWorker](https://github.com/ManageIQ/manageiq/blob/9456ba68a455a5a0501c1e9e0aef88c78dc83338/app/models/manageiq/providers/base_manager/refresh_worker.rb)
* Worker Class: [BaseManager::RefreshWorker::Runner](https://github.com/ManageIQ/manageiq/blob/9456ba68a455a5a0501c1e9e0aef88c78dc83338/app/models/manageiq/providers/base_manager/refresh_worker/runner.rb)

The Refresh Worker is a queue-based worker, which means that the worker responds to specific messages that appear on the [worker queue](https://github.com/ManageIQ/manageiq/blob/98bf676b79f51003ca0404e51d92a8d72bc555d9/vmdb/app/models/miq_queue.rb).  Other processes will enqueue a message requesting a refresh of a particular manager.

The Refresh Worker responds to the request to refresh a manager's inventory.  These requests can come from several different places:

1. Refreshes are triggered for all registered managers when the appliance starts
2. Users can initiate a refresh from the Web UI
3. Events received from the manager can trigger a refresh
4. Refreshes are scheduled to occur once every 24 hours, for all providers, by default

When a refresh request is received by a Refresh Worker, the worker uses the [`EmsRefresh`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/ems_refresh.rb) module to perform the actual refresh.  Each manager implements a refresh process.

Refresh Workers are created for each registered manager.  In other words, if you have registered two Amazon Cloud managers, there will be two unique Amazon Refresh Worker processes running.

Amazon Example:
* Model Class: [`Amazon::CloudManager::RefreshWorker`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/amazon/cloud_manager/refresh_worker.rb)
* Worker Class: [`Amazon::CloudManager::RefreshWorker::Runner`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/amazon/cloud_manager/refresh_worker/runner.rb)

#### Event Workers

TODO

##### Event Catcher

TODO

* Model Class: [`BaseManager::EventCatcher`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/base_manager/event_catcher.rb)
* Worker Class: [`BaseManager::EventCatcher::Runner`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/base_manager/event_catcher/runner.rb)

Amazon Example:
* Model Class: [`Amazon::CloudManager::EventCatcher`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/amazon/cloud_manager/event_catcher.rb)
* Worker Class: [`Amazon::CloudManager::EventCatcher::Runner`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/amazon/cloud_manager/event_catcher/runner.rb)

##### Event Handler

The first thing to notice about the `EventHandler` is that its parts are still located in the legacy locations with legacy names.

The second thing to notice about the `EventHandler` is that there is no manager-specific implementation.  All events are handled by the same handler.

* Model Class: [`MiqEventHandler`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/miq_event_handler.rb)
* Worker Class: [`EventHandler`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/lib/workers/event_handler.rb)

###### Event Mappings

TODO

#### Metrics Workers

TODO

##### Metrics Collector

TODO

* Model Class: [`BaseManager::MetricsCollectorWorker`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/base_manager/metrics_collector_worker.rb)
* Worker Class: [`BaseManager::MetricsCollectorWorker::Runner`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/base_manager/metrics_collector_worker/runner.rb)

Amazon Example:
* Model Class: [`Amazon::CloudManager::MetricsCollectorWorker`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/amazon/cloud_manager/metrics_collector_worker.rb)
* Worker Class: [`Amazon::CloudManager::MetricsCollectorWorker::Runner`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/manageiq/providers/amazon/cloud_manager/metrics_collector_worker/runner.rb)

##### Metrics Processor

The `MetricsProcessor` worker is similar to the `EventHandler`.  Its parts are still in the legacy locations, and there is no manager-specific implementation.

* Model Class: [`MiqEmsMetricsProcessorWorker`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/app/models/miq_ems_metrics_processor_worker.rb)
* Worker Class: [`EmsMetricsProcessorWorker`](https://github.com/ManageIQ/manageiq/blob/fd90bedc57ee51c77bc8fbb6dd2ea850191a8d4f/lib/workers/ems_metrics_processor_worker.rb)
