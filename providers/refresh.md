## Provider Refresh

Of all of the functions that a provider implements, refresh is one of the most critical.  Inventory is the basis for almost every other function that MIQ offers.  Whether provisioning, metrics, event-condition-action, or reporting, all are based on inventory collected from providers.

##### EmsRefresh

A refresh is initiated by a requester through the [`EmsRefresh`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/ems_refresh.rb) class by passing a list of targets (what to be refreshed) to the [`.queue_refresh`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/ems_refresh.rb#L32-L47) method.  The core EmsRefresh class is then responsible for splitting targets up by their ExtManagementSystem [here](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/ems_refresh.rb#L37-L44) and initiating the appropriate provider Refresher class with the list of targets [here](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/ems_refresh.rb#L92-L94).

###### What is a full vs a targeted refresh?

Refresh targets define the scope of what should be collected.  Depending on the targets refreshes are classified into two categories:
1. Full refresh
2. Targeted refresh

In a full refresh the top-level Manager is the target and everything will be collected.  A targeted refresh, by contrast, will only collect inventory related to the specific target(s), greatly reducing the amount of work that has to be done.

Think about creating a new VM, you don't need to ask for every VM again if you could simply ask the provider about that one new VM and its disks/nics/etc...

##### Refresher

Once in the [`Refresher#refresh`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/manageiq/providers/base_manager/refresher.rb#L27-L68) method the provider has the opportunity to perform some pre and post-processing on the targets if they wish, but the bulk of the work is done by the [`Refresher#refresh_targets_for_ems`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/manageiq/providers/base_manager/refresher.rb#L75-L106) method.

Once here the refresh of a target consists of three steps:
1. Collection of inventory from the native provider: [`#collect_inventory_for_targets`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/manageiq/providers/base_manager/refresher.rb#L84)
2. Parsing of the inventory into the normalized MIQ schema: [`#parse_targeted_inventory`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/manageiq/providers/base_manager/refresher.rb#L92)
3. Persisting inventory to the database: [`#save_inventory`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/manageiq/providers/base_manager/refresher.rb#L96)

As a provider author you have the ability to override any of these methods if you wish, but by default we will invoke the helper classes generated by the provider generator.  These classes are under the `ManageIQ::Provider::#{vendor}::Inventory` namespace and map to the three components of refresh: collect, parse, persist.

###### Inventory::Collector

A collector encapsulates how inventory is retrieved from the management system and is typically the only part of a refresh that issues API calls.  At first this can seem like extra overhead as the parser could just as easily also collect inventory, but this becomes important when also implementing targeted refresh.  By controlling what is returned from the collector you can typically reuse the Parsers for full and targeted refresh.

For example your "full" collector might look like:
```ruby
class ManageIQ::Providers::MyProvider::Inventory::Collector::CloudManager
  def vms
    connection.all_vms
  end
end
```

And your "targeted" collector:
```ruby
class ManageIQ::Providers::MyProvider::Inventory::Collector::TargetCollection
  def vms
    targets.collect { |target| connection.get_vm(target.instance_id) }
  end
end
```

This way your parser can call `collector.vms` without having to care if it is performing a full or a targeted refresh.

###### Inventory::Persister

It might seem a little out of order to talk about the persister before the parser, but a lot of concepts here are required to understand how the parser works.

The persister class defines the set of inventory collections included in the refresh.  An inventory collection defines how records are saved to the database.

Typically inventory collections map to models/database tables, for example the `vms` collection saves records to the `"vms"` table.  The inventory collections will contain an array of `InventoryObject` which will become the records which are created in that table.

The persister also defines what will be deleted as part of a refresh.  The saver will delete the complement of what is in the inventory collection based on a certain scope.  During a full refresh this scope is the entire association (e.g. the equivalent of `ems.vms.all`) and during a targeted refresh the scope is basically the set of targets.

The builtin collections come from the core [`ManageIQ::Providers::Inventory::Persister`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/manageiq/providers/inventory/persister.rb) classes.  Each manager type has their own set of collections defined by the `Persister::Builder` subclass, e.g. here is the default set for an [`InfraManager`](https://github.com/ManageIQ/manageiq/blob/jansa-1-beta1/app/models/manageiq/providers/inventory/persister/builder/infra_manager.rb).  Your provider plugin's persister class adds collections from this "menu" using the `add_collection` method.

You can modify properties of these builtin collections by providing a block to the `add_collection` call, as well as adding entirely new collections if you want.

It is also possible to define collections with a "custom save block" where you can do anything that doesn't fit into the typical model saver.

For a deep dive into the inventory collection options check out the [Inventory Collection](persister/inventory_collections.md) documentation.

###### Inventory::Parser

The parser is where the majority of the refresh logic lives.  It is here that the data transformation between the native provider schema and the ManageIQ schema happens.

This typically consists of changing property names to match MIQ columns, changing property units, and linking inventory together.

The parser builds Inventory Objects in the different Inventory Collections which are then saved as records in the database by save_inventory.

```ruby
def vms
  # Loop through the collected vms
  collector.vms.each do |vm|

    # Build an InventoryObject in the vms inventory collection
    persister.vms.build(
      :name    => vm.name,
      :ems_ref => vm.id,  # Make sure that you populate all of the collection's
                          # manager_ref attributes
    )
  end
end
```

The Inventory Collections define a "manager_ref" which is a combination of columns which indicate uniqueness within a collection.  For most "top-level" models e.g. Vms, Hosts, etc... this is just the ems_ref column.

The trickiest part of parsing is linking records together.  This is done by using the `#lazy_find` mechanism that the inventory_collections provide.  Essentially what this does is instruct the save_inventory code to resolve a query later when all dependencies are satisfied.

To create a lazy link to another object you have to specify the collection and how to find the object.  If we take a VM on a host as an example:

```ruby
def vms
  collector.vms.each do |vm|
    # You have to find an attribute that maps to a unique attribute in the other
    # collection so that the object can be found during saving
    # Ideally the manager_ref of that collection but it is possible to use other
    # attributes
    host_ems_ref = vm.host_id

    # Then you pass the unique attribute to the `lazy_find` method off of the
    # collection that you are trying to link to
    host = persister.hosts.lazy_find(host_ems_ref)
    persister.vms.build(

      # We set the lazy find to the name of the association that we're trying to
      # populate.  In this case it is the host_id column for the `belongs_to :host`
      # association.
      :host => host
    )
  end
end
```

This lazy find will be resolved during saving after the hosts collection is saved.  This allows for links between records to be specified even before the object being linked to is saved yet, for example during a full refresh no hosts nor vms have been saved so doing `ems.hosts.find_by(:ems_ref => vm.host_id)` wouldn't find anything.

In the rare case that you don't have access to the primary manager_ref attributes it is possible to use a "secondary_ref".  This is an attribute that can be specified on the persister inventory_collection and the saver will maintain additional indices so that records can be looked up in a performant manner.  It is critical that these secondary refs are also unique.

For example lets say that we have the host UUID not the host ems_ref when trying to link a vm to a host.

We can add a secondary_ref on host#uuid to the hosts inventory collection:
```ruby
add_collection(infra, :hosts, :secondary_refs => {:by_uuid => %i[uuid]})
```

Then in our parser we can do the following:
```ruby
persister.vms.build(
  :host => persister.hosts.lazy_find({:uuid => vm.host_uuid}, {:ref => :by_uuid})
)
```
