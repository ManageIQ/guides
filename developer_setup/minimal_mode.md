ManageIQ allows developers to start minimal services and/or the rails app via a "minimal" mode setting when starting the application.  Starting in minimal mode limits the number of workers that are started for a quicker application startup, or for targeted end-user testing of specific pieces of the application.

## Standard Startup

In development, to start the application in standard mode, run:

    $> rake evm:start

This command will start the following workers:

* two generic workers
* two priority workers
* two reporting workers
* one schedule worker
* one UI worker
* one web service worker
* any additional event workers (based on configured External Management Systems)
* any additional refresh workers (based on configured External Management Systems)

## Strict Minimal Startup

In development, to start the application in minimal mode, run:

    $> MIQ_SPARTAN=minimal rake evm:start

The `MIQ_SPARTAN` environment variable is inspected by the `MiqServer` class (specifically, the `EnvironmentManagement` mixin), which determines whether the application is starting in a minimal mode.  In this strict minimal mode, the following workers are started:

* one generic worker
* one UI worker

## Specific Minimal Startup

ManageIQ allows developers to augment the minimal startup mode by specifying a colon-separated list of worker roles.  These worker roles are used to determine which workers should be started in addition to the strict minimal list above.

To start the application with a specific set of workers in minimal mode, run

    $> MIQ_SPARTAN=minimal:<role_name>:<role_name> rake evm:start

Following is a mapping of role names to worker types:

|Role name                |Worker                                                                    |
|-------------------------|--------------------------------------------------------------------------|
|control                  |`miq_control_monitor`                                                     |
|database_synchronization |`miq_replication_worker`                                                  |
|ems_inventory            |`miq_vim_broker_worker`, `miq_ems_refresh_worker`, `miq_ems_refresh_core_worker`|
|ems_metrics_collector    |`miq_vim_broker_worker`, `miq_ems_metrics_collector_worker`               |
|ems_metrics_processor    |`miq_ems_metrics_processor_worker`                                        |
|ems_operations           |`miq_vim_broker_worker`                                                   |
|event                    |`miq_event_catcher`, `miq_event_handler`                                  |
|reporting                |`miq_reporting_worker`                                                    |
|schedule                 |`miq_schedule_worker`                                                     |
|smartproxy               |`miq_smart_proxy_worker`, `miq_vim_broker_worker`                         |
|smartstate               |`miq_vim_broker_worker`                                                   |
|storage_inventory        |`miq_netapp_refresh_worker`, `miq_smis_refresh_worker`                    |
|storage_metrics_collector|`miq_storage_metrics_collector_worker`                                    |
|user_interface           |`miq_ui_worker`                                                           |
|vmdb_storage_bridge      |`miq_vim_broker_worker`, `miq_vmdb_storage_bridge_worker`                 |
|web_services             |`miq_web_services_worker`                                                 |
| | |
|no_ui                    |Prevent starting the UI worker normally provided by minimal               |

For example, to start in minimal mode with event catching and EMS refreshing enabled, run:

    $> MIQ_SPARTAN=minimal:event:ems_inventory rake evm:start

Note:

* A value specified in MIQ_SPARTAN will not start the worker if the server is not configured with that role.  All MIQ_SPARTAN does is filter down the existing list of assigned server roles to a smaller set.
* Some of the workers can be started with different roles
    * For example, `miq_vim_broker_worker` can be started with any of
        * vmdb_storage_bridge
        * smartstate
        * smartproxy
        * ems_operations
        * ems_metrics_collector
        * ems_inventory
* All of these workers are subclasses of [`MiqWorker::Runner`](https://github.com/ManageIQ/manageiq/blob/81bd2df11c9bb60a839b97a0d140958f9a4bc132/app/models/miq_worker/runner.rb)
* Some workers will only start if there is a corresponding External Management System configured, such as the `miq_ems_refresh_worker`.

## Some Suggested Startups

|Values|Purpose|
|-------|-------|
|`minimal:ems_inventory:event`|Testing EMS Refresh and Eventing from a provider|
|`minimal:no_ui:reporting`|Testing UI changes, when needed to run the UI through a debugger instead of a worker|
|`minimal:schedule`|Testing real world schedules|

## Enabling Direct URLs

By default the ManageIQ console does not allow direct browsing to most URLs (you must be referred by using a link in the
UI). This can be cumbersome in a development environment when a request is unsuccessful and you wish to simply refresh
the page after making changes necessary changes - you will be given a `403 - Forbidden` response and be required to log
in again.

You can set the environment variable `MIQ_DISABLE_RRS` to disable this behavior and allow for direct URL browsing:

    $> MIQ_DISABLE_RRS=1 rails server

