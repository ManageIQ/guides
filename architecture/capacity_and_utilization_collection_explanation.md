# Capacity And Utilization

1. A capture request is kicked off by the schedule worker every so often (configurable, 10 minutes with a 50 minute threshold).
1. The capture request finds all VMs and Hosts (and Storages, but those are different) enabled for capture (configurable).
1. For each target it then queues up a capture.
1. A collector worker will pick up one of these work items, collect the data since the last capture, and write new records in the metrics table.
1. Then the worker queues up a rollup (explained below).
1. A processor worker will pick up one of these rollup work items and queue up ANOTHER rollup for the next stage of the rollup chain.
1. This continues until we hit the end of the chain.

After enabling the Capacity & Utilization Collector Role, data collection begins immediately.  However, the first collection begins 5 minutes after the CFME Server is started, and every 10 minutes after that. Therefore, the longest the collection will take after enabling the Capacity & Utilization Collector CFME Server Role is 10 minutes. The first collection from a particular management system may take a few minutes since CFME is gathering data points going one month back in time

## Rollups
There are two types of rollups, **time-based** and **infrastructure-based**.
* **Time-based** rollups go from realtime → hourly → daily.
* **Infrastructure-based** rollups for hourly go from `Vm` → `Host` → `EmsCluster` → `ExtManagementSystem` → `MiqRegion` (and maybe to `MiqEnterprise`?).

### Example

Say we do a capture on a VM and we get back data with timestamps between 4:05 and 4:15.  This would cause records to be written in the metrics for each interval.  Then, it would put a rollup on the queue for that VM for the 4:00 hour *(time-based)*.  A processor worker will pick up that queue item, gather all of the real-time records for that VM for the 4:00 hour, and write a rollup hourly record for that VM.  Then it will queue up 2 more rollups. One rollup is for the parent Host of that VM for the 4:00 hour *(infrastructure-based)*, and another is for that VM for the day *(time-based)*.

Below is the full tree of rollups that will occur:

~~~
Vm (realtime collected)
 Vm (hourly)
   Vm (daily)
   Host (hourly)
     Host (daily)
     EmsCluster (hourly)
       EmsCluster (daily)
       ExtManagementSystem (hourly)
         ExtManagementSystem (daily)
         MiqRegion (hourly)
           MiqRegion (daily)
~~~


That is the simplest description. In reality, there are some nuances that should be mentioned.

* **We collect data that spans hours** (e.g. we collect 3:50-4:15), so a separate rollup is put on the queue for each hour in question, and the chain begins separately for each.

* **Rollups are queued up for a particular hour or day, but don't actually execute until the end of that time period**.  As captures queue up rollups for the same parameters (e.g. for Vm:1 for the 4:00 hour), they are merged on the queue, so you only end up with one rollup record.  If a rollup is being executed and new data comes in for that hour (e.g. from a gap collection, or collection falls behind), then a new queue item will be placed for those same parameters.  This is ok as the rollup code recognizes when it has to update existing records.

* **The definition of a day is actually more complex**.  A day is a different range of hours depending on your time zone.  We accomplish managing this with Time Profiles.  Time Profiles represent a time zone as well as a set of hours and days that are considered valid.  This way a customer can create a Time Profile that represents an entire time zone or just their business hours in a particular time zone (e.g. Eastern Time 9-5 M-F).  Part of setting up a time profile is to choose whether or not it will participate in daily rollups.  UTC is provided OOtB with daily rollups enabled.  Therefore, as far as daily rollups are concerned, the truth is that a daily rollup is queued for each Time Profile that has daily rollups enabled.

* **Storages are slightly different.  Their information is collected from our storage scans**, so if you've never scanned a Storage, you won't get any data. Storages rollup directly to their EMS, I think.  Also, they are run on a different schedule.

* **Cloud rollups** *(coming soon)* will go from `Vm` → `Availability Zone` → `ExtManagementSystem` → `MiqRegion`.

## Notes on Testing Rollups
* **Rollups are automatic behind the scenes and are triggered by a collection**.  Therefore, if you try to manually inject data, you are not really running a collection and thus won't get rollups.

* **A capture of a Vm can be kicked off in a rails console with `vm.perf_capture("realtime")`**.  The rollups on the queue can be executed without a worker by just delivering them from the queue

    ``` ruby
    q = MiqQueue.find
    q.delivered(*q.deliver)
    ```

    If you want to fake creating rollups, you can just do `vm.perf_rollup_to_parent("realtime", start_time, end_time)`, which queues them up and starts the chain.

* **Database tables are not ordered sets of data, so if you did a straight query they are not guaranteed to appear in any particular order.**  In addition, due to the nature of multiple workers, data may get written in different orders, especially if records have to be updated.  It may be helpful to order by timestamp and filter against `resource_type`, `resource_id`, `capture_interval_name`.


## TODO: Notes on why we use Postgres inheritance, and why metrics and metrics_rollups are in separate tables.
