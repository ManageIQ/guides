## Targeted Refresh

If you followed the [Creating a new provider](writing_a_new_provider.md) guide then you already have a provider with full refresh working.  Or maybe you're working on an existing provider that only has full refresh and you'd like to add targeted refresh to it.

### What is targeted refresh?

First we should get some technicalities out of the way.  All refreshes have a target, "full" refresh is when the target is the top-level EMS and "targeted" refresh is when the target is anything else (for example a single VM).

The primary benefit of targeted refresh is speed.

Even a moderately large provider will start to take minutes to collect and save all of the inventory.  Doing this simply to pick up a single new VM is extremely wasteful.  Also only one refresh is able to run at a time due to concurrency concerns.  This means if a full refresh takes 10 minutes and you queue up your refresh request right after it starts, then the "latency" to getting your change into the database could take almost 20 minutes.  By contrast fetching a single resource like a VM and related inventory is extremely fast.

There are two main differences between targeted refresh and full refresh:

1. What is collected
2. How inventory is deleted

Targeted refresh only fetches inventory from the provider for the targets requested.  This cuts down on API calls and uses less memory.

As for deletions, the most significant difference with targeted refresh is the "scope".  A full refresh considers the entire association (e.g.: `ems.vms.all`) to be in scope, so if something is in the association but not in the collected inventory it will be deleted.

Targeted refresh requires scope to be limited, otherwise everything besides what you targeted would be deleted.  Most of this is abstracted away from the provider author but it is important to understand the fundamentals.  This is covered in way more detail in the [Provider Refresh](refresh.md) guide.

### Getting Started

The first thing to do is to set up the new classes that we need.  We'll need to add a `TargetCollection` class under the `Collector` and `Persister`.

```ruby
class ManageIQ::Providers::AwesomeCloud::Inventory::Collector::TargetCollection < ManageIQ::Providers::AwesomeCloud::Inventory::Collector
end
```

```ruby
class ManageIQ::Providers::AwesomeCloud::Inventory::Parser::TargetCollection < ManageIQ::Providers::AwesomeCloud::Inventory::Parser
end
```

```ruby
class ManageIQ::Providers::AwesomeCloud::Inventory::Persister::TargetCollection < ManageIQ::Providers::AwesomeCloud::Inventory::Persister
  # Indicates that this is a targeted refresh
  def targeted?
    true
  end
end
```

And don't forget to add `require_nested :TargetCollection` to `app/models/manageiq/providers/awesome_cloud/inventory/collector.rb`, `app/models/manageiq/providers/awesome_cloud/inventory/parser.rb`, and `app/models/manageiq/providers/awesome_cloud/inventory/persister.rb`

We also have to add a configuration setting to enable/disable targeted refresh in your provider's `config/settings.yml`:
```
:ems_refresh:
  :awesome_cloud:
    :allow_targeted_refresh: true
```

We should now have all of the scaffolding in place to start implementing the targeted collector.  The goal is that the parser and persister are basically identical in full and targeted refresh and only the collector has to change.

### Targeted Collection

Now that we have the basics down we can begin writing the targeted collector.  Again this is where the majority of the work will be as long as we've done everything correctly.

First we have to override each collection that is defined in the base Collector:

```ruby
class ManageIQ::Providers::AwesomeCloud::Inventory::Collector::TargetCollection < ManageIQ::Providers::AwesomeCloud::Inventory::Collector
  def images
    []
  end

  def instances
    []
  end

  def instance_types
    []
  end
end
```

This just ensures that we won't accidentally go out and fetch the entire collection.

Now we need to parse the targets that are passed in.

```ruby
class ManageIQ::Providers::AwesomeCloud::Inventory::Collector::TargetCollection < ManageIQ::Providers::AwesomeCloud::Inventory::Collector
  def initialize(_manager, _target)
    super

    parse_targets!
  end

  ...

  private

  def parse_targets!
    # `target` here is an `InventoryRefresh::TargetCollection`.  This contains two types of targets,
    # `InventoryRefresh::Target` which is essentialy an association/manager_ref pair, or an ActiveRecord::Base
    # type object like a Vm.
    #
    # This gives us some flexibility in how we request a resource be refreshed.
    target.targets.each do |target|
      case target
      when MiqTemplate
        add_target!(:miq_templates, target.ems_ref)
      when Vm
        add_target!(:vms, target.ems_ref)
      end
    end
  end
end
```

That will add the `InventoryRefresh::Target` that we can reference in the collector.

Now lets write our `instances` collector method:
```ruby
def instances
  @instances ||= begin
    references(:vms).map do |ems_ref|
      compute_client.get_instance(ems_ref)
    end
  end
end
```

This allows our parser to work exactly the same way, calling `collector.instances` returns an array of instance objects to be parsed.  The parser doesn't even have to know that it is one or two instances versus all of them.

Continue adding targeted methods for the images collection and any others that you wish to be able to target specifically.

It is critical that if your parser depends on other top-level collections (e.g. the instances parser requires that "disks" or "network_ports" be collected from the API) then you _must_ add collector methods for these.  If you don't then targeted refreshes of new inventory will be incomplete and targeted refreshes of existing inventory will delete those dependent collections.

### Testing

Now let's test it out.  First we can do a manual test, we can run this test from a rails console:
```
rails c
ems = ManageIQ::Providers::AwesomeCloud::CloudManager.first
EmsRefresh.refresh(ems) # Run a full refresh to ensure we are up to date
vm = ems.vms.first
EmsRefresh.refresh(vm) # Now we can target individual vms!
```

You can change something (like the name or description) and confirm that it gets picked up by the targeted refresh.

If you want to target a new vm (e.g. something that isn't in the database yet) then you can use the `InventoryRefresh::Target` notation.  It is a little less convenient to use in quick testing but is better otherwise.

Try creating a new VM in your cloud console and copy its unique reference (just "1234" in this example), then run the following command:
```
rails c
ems = ManageIQ::Providers::AwesomeCloud::CloudManager.first
target = InventoryRefresh::Target.new(:manager => ems, :association => :vms, :manager_ref => {:ems_ref => "1234"})
EmsRefresh.refresh(target)
ems.reload
ems.vms.find_by(:ems_ref => "1234")
```

### Conclusion

And that's all you need to get started!  Targeted refresh is most helpful when paired with an event catcher which we will cover next.

Even without an event catcher you can use this (e.g. in a provisioning workflow after the VM is created) in lieu of the full refresh, as this can greatly reduce the time each provision request takes.
