## Events

Events are one of the primary functions of a provider, in addition to Inventory, Metrics, and Operations.  Adding an event catcher to your provider is extremely helpful for improving overall performance of the system because it allows us to react to changes as they happen rather than resort to polling.

There are three primary uses for events in MIQ:

1. Allowing users to trigger custom event-condition-action via the automate event switchboard
2. Displaying the event timeline for a resource on the UI
3. Triggering provider refresh

We'll primarily focus on #3 here since the first two come "for free" once you start creating events but initiating a provider refresh (particularly a targeted refresh) takes a bit more work.

### Overview

All provider events use the `EmsEvent` model which derives from the `EventStream` base class.  There are also internal `MiqEvent`s but we are going to focus on `EmsEvent`s.

The pipeline for catching, parsing, and saving events is optimized to ensure that the chance of missing an event is minimized.

To that end catching and parsing events is separate from saving them to the database and relating them to other inventory.  Typically providers even implement catching and parsing in different threads within the event catcher.

The overall flow looks like this:

```
(Native Provider)  --->   (Event Catcher Thread)  ---->  (Event Catcher Parser)  ----->  (MiqEventHandler)  -> (VMDB)
               Emits an event                  Internal Queue                 MiqQueue.put
```

### Writing an Event Catcher

First we need to set up the worker scaffolding so that we can run our event catcher worker.

`config/settings.yml`
```yaml
:ems:
  :ems_awesome_cloud:
    :blacklisted_event_names: []
    :event_handling:
      :event_groups: {} # Add your event names under the appropriate groups here

:workers:
  :worker_base:
    :event_catcher:
      :event_catcher_awesome_cloud:
        :poll: 15.seconds
```

`app/models/manageiq/providers/awesome_cloud/cloud_manager/event_catcher.rb`
```ruby
class ManageIQ::Providers::AwesomeCloud::CloudManager::EventCatcher < ManageIQ::Providers::BaseManager::EventCatcher
  require_nested :Runner
end
```

`app/models/manageiq/providers/awesome_cloud/cloud_manager/event_catcher/runner.rb`
```ruby
class ManageIQ::Providers::AwesomeCloud::CloudManager::EventCatcher::Runner < ManageIQ::Providers::BaseManager::EventCatcher::Runner
  # This is the main method run in the first thread by the core event catcher runner.
  # It is responsible for retrieving events from the provider and putting them on
  # an internal queue for the core runner thread to parse and put on MiqQueue.
  def monitor_events
    # Start up our event monitor
    event_monitor_handle.start

    # Tell the core runner thread that the event monitor is started.  The worker
    # won't be marked as "running" until this happens.
    event_monitor_running

    # And finally poll for events.  This should be implemented as a blocking method
    # which yields events caught from the provider
    event_monitor_handle.poll do |event|
      @queue.enq(event)
    end
  ensure
    stop_event_monitor
  end

  # This method is called by core when shutting down the event catcher
  def stop_event_monitor
    event_monitor_handle.stop
  end

  # This is called by the core runner thread to parse and put the event on the queue.
  def queue_event(event)
    event_hash = ManageIQ::Providers::AwesomeCloud::CloudManager::EventParser.event_to_hash(event, @cfg[:ems_id])
    EmsEvent.add_queue('add', @cfg[:ems_id], event_hash)
  end

  private

  # The Stream class isn't a requirement but helps to encapsulate the logic of
  # fetching events from the provider.
  def event_monitor_handle
    @event_monitor_handle ||= begin
      self.class.module_parent::Stream.new
    end
  end
end
```

The Stream implementation is going to be very specific to your provider, this is just an example of how one might look.

`app/models/manageiq/providers/awesome_cloud/cloud_manager/event_catcher/stream.rb`
```ruby
class ManageIQ::Providers::AwesomeCloud::CloudManager::EventCatcher::Stream
  attr_reader :ems, :stop_polling, :poll_sleep

  def initialize(ems, options = {})
    @ems = ems
    @stop_polling = false
    @poll_sleep = options[:poll_sleep] || 20.seconds
  end

  def start
    @stop_polling = false
  end

  def stop
    @stop_polling = true
  end

  def poll
    since = nil

    loop do
      ems.with_provider_connection(:service => "Events") do |events_client|
        # Replace with your provider's events API
        events = events_client.get_events(:since => since)
        since = Time.now.utc

        break if stop_polling

        events.each { |event| yield event }
      end
      sleep(poll_sleep)
    end
  end
end
```

### Parsing events

Now that we're catching events from the provider we need to implement the parser.  This is called by the main event catcher runner thread prior to putting events onto MiqQueue for the MiqEventHandler to process.

The purpose of this is similar to the inventory parser, to translate the native provider event into the VMDB schema.

`app/models/manageiq/providers/awesome_cloud/cloud_manager/event_parser.rb`
```ruby
module ManageIQ::Providers::AwesomeCloud::CloudManager::EventParser
  def self.event_to_hash(event, ems_id)
    event_hash = {
      :event_type => event[:event_name],
      :source     => "AWESOME_CLOUD",
      :ems_ref    => event[:id],
      :timestamp  => event[:time],
      :full_data  => event,  # Make sure this serializes properly and isn't dumping a native object
    }

    # Parse any additional information e.g. instances, images, etc...
    case event_hash[:event_type]
    when /com.awesome-cloud.vm/
      parse_vm_event!(event, event_hash)
    end

    event_hash
  end

  def self.parse_vm_event!(event, event_hash)
    return if event[:vm].nil?

    # The uid_ems/ems_ref should match the attributes that you set in the inventory
    # parser since they will be used to lookup the VM object by the MiqEventHandler
    event_hash[:vm_uid_ems] = event.dig(:vm, :id)
    event_hash[:vm_ems_ref] = event.dig(:vm, :id)
    event_hash[:vm_name]    = event.dig(:vm, :name)
  end
end
```

And with that you should be able to catch events and have them saved to the database!

To test this out you can run `simulate_queue_worker` in a rails console (this will act as your `MiqEventHandler`) and then your can run you event catcher with `run_single_worker`:

```
lib/workers/bin/run_single_worker.rb --role=event --ems-id=2 ManageIQ::Providers::AwesomeCloud::CloudManager::EventCatcher
```

### Using events for targeted refresh

This is where things get interesting, combining an event catcher with targeted refresh allows you to automatically build the `InventoryRefresh::Target` that we saw in the [Targeted Refresh Guide](targeted_refresh.md) based on the event data.  You can also use the event payload to pre-seed your targeted collector with information to save on API calls.

The first step is to create automate event handlers for each of the events that you want to trigger a targeted refresh.  These live in the https://github.com/ManageIQ/manageiq-content repository.

Create a directory to hold your events: `content/automate/ManageIQ/System/Event/EmsEvent/AWESOME_CLOUD.class/`

Then in this directory create a file that matches the event_type for each of your events:
`content/automate/ManageIQ/System/Event/EmsEvent/AWESOME_CLOUD.class/com.awesomecloud.vm.create.yaml`
```yaml
---
object_type: instance
version: 1.0
object:
  attributes:
    display_name:
    name: com.awesomecloud.vm.create
    inherits:
    description:
    relative_path: System/Event/EmsEvent/AWESOME_CLOUD/com.awesomecloud.vm.create
  fields:
  - rel4:
      value: "/System/event_handlers/refresh" # This action is what will kick off a targeted refresh
```

With that in place the `MiqEventHandler` is going to invoke automate, and automate is going to call the refresh event_handler.

For this to work we have to expose a way for core to convert our provider event to a list of refresh targets.  This is done with the `EventTargetParser` class.

`app/models/manageiq/providers/awesome_cloud/cloud_manager/event_target_parser.rb`
```ruby
class ManageIQ::Providers::AwesomeCloud::CloudManager::EventTargetParser
  attr_reader :ems_event

  def initialize(ems_event)
    @ems_event = ems_event
  end

  def parse
    target_collection = InventoryRefresh::TargetCollection.new(
      :manager => ems_event.ext_management_system,
      :event   => ems_event
    )

    raw_event = ems_event.full_data

    if raw_event[:vm]
      target_collection.add_target(:association => :vms, :manager_ref => {:ems_ref => raw_event[:vm][:id])
    end

    # Add in other resource types that you might want to handle here

    # Return the set of targets from this event
    target_collection.targets
  end
end
```

Now when an event is caught the event handler should automatically queue a targeted refresh with pre-parsed targets.

With that you can now bump your refresh interval from 15 minutes up to 1 day.

```yaml
---
:ems_refres:
  :awesome_cloud:
    :refresh_interval: 24.hours
```

This ensures that the provider inventory doesn't get too far out of sync while freeing up the refresh worker to process way more targeted refreshes without having to do a full every 15 minutes.
