# Inventory Collection
2018/06/19

[back](../dev-guide.md)

**Inventory Collection** (```ManagerRefresh::InventoryCollection``` - subsequently called **"IC"**) is an object used by Refresh process. 
It represents types of inventory such as **VM**, **Hardware**, **Operating system**, **Host** etc.

Each IC is defined by persister (```ManagerRefresh::Inventory::Persister```), stored in a hash called ```@collections``` and accessible as persister's method. It's name is equal to the IC's association property (will be described later). One persister usually contains many IC definitions.

## Defining an Inventory Collection

We can split this process into following areas:

- Persister's helper
  - includes *add_collection()* interface common to all persisters derived from ```ManagerRefresh::Inventory::Persister```
- InventoryCollection Builder
  - set of classes used for definition of IC properties (through add_collection())
- Common definitions
  - Definitions of ICs shared accross providers divided by provider's type (cloud/infra etc.)
- Provider specific definitions
  - Recommendations how to structure definitions specifical to provider and type of refresh

## Persister's helper

### add_collection() method

_This interface is intended to replace older interfaces ```add_inventory_collection()``` and ```has_inventory()```_

Entry point for creating IC definition. It defines parameters:
```ruby
add_collection(builder_class, collection_name, extra_properties = {}, settings = {}, &block)
```
which we'll see more detailed in this chapter.

It creates ```ManagerRefresh::InventoryCollection```  and assigns it to **persister's @collections[:vms]**

Method can throw exception **`ManagerRefresh::InventoryCollection::Builder::MissingModelClassError`** (described [later](#automatic-model_class))

#### - builder_class [*mandatory*]

There is a builder class for every manager type. Because they're used as parameter of ```add_collection()``` they are wrapped to methods with short name (persister's methods):
- cloud
- infra
- network
- storage
- automation
- [see details](https://github.com/ManageIQ/manageiq/blob/master/app/models/manager_refresh/inventory_collection/builder/persister_helper.rb#L39-L62)

_**Note**: Not all ICs defined in ..Builder::NetworkManager have to be called only from NetworkManager (e.g. in case of targeted refresh) etc._

##### Example

```ruby
add_collection(cloud, :vms)
```

Instantiates `cloud` builder class, searches for `vms` method in it, searches for ```...::CloudManager::Vm``` as model_class property and discovers model_class attributes.

#### - collection_name [*mandatory*]

Name (also `InventoryCollection.association`) is unique identifier of IC definition (in scope of one persister). 

It has several functions:

- name of IC 
- key in persister's @collections hash
- name of persister's public method
- name of method in builder class with common properties (if exists)

Collection name is also used for automated assignments, such as:

- ```:model_class``` (where are collected data persisted)  [*below*]
- ```:inventory_object_attributes``` - "columns" of model_class [*below*]

#### - extra_properties [*optional*]

Properties added to IC at **top level priority**.  
It overwrites both shared and IC specific properties. Added by ```Builder#add_properties()```.

#### - settings [*optional*]

Mix of builder settings and shared properties for from ICs.  
*Shared properties* are low-level IC's properties common for all ICs defined in persister. They consist of advanced settings and shared options.

*Builder settings* can turn on/off various builder features.

##### Advanced settings

Contains shared properties from UI's Configuration/Advanced settings, which **can be set by user** (typically ```:saver_strategy``` property).

Applied at **lowest level priority** so these properties cannot overwrite properties written in code. 

Can be found in tab Advanced(yaml editor):
```
ems/ems_refresh/<ExtManagementSystem.ems_type>/inventory_collections/
```

##### Shared options

Contains shared properties for all ICs defined in persister's method ```shared_options()```.
Usually have properties _**:targeted**_, _**:strategy**_ and _**parent**_

Applied at **low level priority** so these properties overwrites Advanced settings but doesn't overwrite IC specific properties.

##### Builder settings

- **auto_inventory_attributes** [Boolean] - Enables automatic settings of InventoryObject attributes ("columns" of model_class). Default: true
- **without_model_class** [Boolean] - When true, disables automatic derivation of ```:model_class``` and doesn't throw exception when not set manually. Default: false

##### Example

```ruby
add_collection(cloud, :vm_and_miq_template_ancestry, {}, {:auto_inventory_attributes => false, :without_model_class => true)
```

#### - block

Block will provide you instance of ```builder_class```. It's place where you can define specific properties. Described in next chapter.

##### Example

```ruby
add_collection(infra, :custom_ic_definition) do |builder|
  builder.add_properties(:model_class => ::MySpecialClass)
end
```

### InventoryCollection Builder

Contains two basic things:
- Methods for construction InventoryCollection with their properties
- Common IC definitions usable accross providers
- Subclasses with IC definitions usable for providers of certain type

Features for defining IC:
- *add_properties*
  - basic function to add properties to IC
- *add_default_values*
  - properties inside properties, usually containing lambdas with persister param.
  - fills IC object with predefined values
  - lambdas evaluated in persister's add_collection()
- *automatic model_class* derivation
- *automatic inventory object attributes* derivation

You can see all functions described in spec [link](https://github.com/ManageIQ/manageiq/blob/master/spec/models/manager_refresh/inventory_collection/builder_spec.rb#L24).

#### Automatic model_class 

**```model_class```** property contains class where are stored data from inventory.  
There are two attemps:
- find provider specific class
- find generic class

Provider specific class is composed by:
- provider module of persister
  - e.g. `ManageIQ::Providers::Amazon`
- manager module of builder
  - e.g. `CloudManager`
- collection_name (association property) of IC
  - e.g. `Vm`
- => **`ManageIQ::Providers::Amazon::CloudManager::Vm`**

If this class doesn't exist, generic class **Vm** is tested for presence. 

_**Note**: Automatic choice is **always** overwritten by manual setting, either in common definitions or in provider specific definition._

If neither any class matches criteria nor model_class defined manually, ```add_collection``` throws **`ManagerRefresh::InventoryCollection::Builder::MissingModelClassError`** exception.  
You can disable it by builder setting *without_model_class* => **true**.

#### Automatic InventoryObject attributes

**```inventory_object_attributes```** property contains possible columns of *model_class*. These attributes are constructed from setter methods of model_class (```model_class#some_method=```).  
It fits 99% of IC definitions, for there rest you can use builder methods:
- *add_inventory_attributes*
- *remove_inventory_attributes*
- *clear_inventory_attributes*

Or you can disable this feature by builder setting *auto_inventory_attributes* => **false** and define your own by methods above.

### Common definitions

Many of IC definitions are common to 2+ providers, for example ```:vms```. That's why their properties were extracted to builder so defining IC in provider is then very simple.

#### Example
Let's look how it works:

```ruby
add_collection(infra, :host_networks)
```

This simple definition performs following steps:

- Infra builder == ```::ManagerRefresh::InventoryCollection::Builder::InfraManager```
- It searches for ```::ManagerRefresh::InventoryCollection::Builder::InfraManager#host_networks``` method
- There is manually defined *model_class* **::Network**
- *inventory_object_attributes* are derived from **::Network** class
  - _**Important**: If ```model_class``` is defined in common definitions, provider specific class **is not derived automatically** even if it exists!_

So properties given to `InventoryCollection` object are following:
```ruby
{
  :association => :host_networks,
  :model_class => Network,
  :manager_ref => [:hardware, :ipaddress],
  :parent_inventory_collection => [:hosts],
  :inventory_object_attributes => [:id, :attributes, :device_id, :default_gateway, 
                                   :description, :destroyed_by_association, 
                                   :dhcp_enabled, :dhcp_server, :domain, :dns_server, 
                                   :guest_device, :guid, :hardware_id, :hostname, 
                                   :href_slug, :ipaddess, :ipv6address, :lease_expires, 
                                   :lease_obtained, :region_description, :region_number, 
                                   :subnet_mask],
  :default_values => {},
  :dependency_attributes => {}
}
```

#### Example 2
```ruby
add_collection(infra, :host_networks) do |builder|
  builder.add_properties(
    :strategy => :local_db_find_references,
    :targeted => false
  )
  builder.add_default_values(
    :ems_id => 1
  )
```

produces `InventoryCollection` attributes:

```ruby
{
  :association => :host_networks,
  :model_class => Network,
  :manager_ref => [:hardware, :ipaddress],
  :parent_inventory_collection => [:hosts],
  :inventory_object_attributes => [<same as previous example>],
  :default_values => {:ems_id => 1},
  :dependency_attributes => {},
  :strategy => :local_db_find_references,
  :targeted => false
}
```


### Provider specific definitions

Following conventions should be applied:
- define collections belonging to CloudManager (using `cloud` Builder) in concern <persister's path>/definitions/cloud_manager.rb
- define collections belonging to NetworkManager (using `network` Builder) in concern <persister's path>/definitions/network_manager.rb
- define `shared_options` method with common properties, if possible
- redefine `targeted?` method to true if it's persister for targeted refresh

#### Example

Let's consider persister for cloud_manager in Amazon: 
- ```ManageIQ::Providers::Amazon::Inventory::Persister::TargetCollection```

Simple definition of :vms is following:
```ruby
add_collection(cloud, :vms)
```

It produces IC with attributes:
```ruby
{
  :association => :vms,
  :strategy => :local_db_find_missing_references, 		# defined in shared_options()
  :targeted => true, 						# defined in shared_options()
  :parent   => <ManageIQ::Providers::Amazon::CloudManager>, 	# defined in shared_options()
  :saver_strategy => :default, # defined in ManagerRefresh::InventoryCollection::Builder::Shared#vms
  ...
  :model_class => ManageIQ::Providers::Amazon::CloudManager::Vm, # derived automatically
  :inventory_object_attributes => [...], 			 # derived automatically
  :default_values => {
    :ems_id   => 1234567, # defined as lambda block
    :vendor   => "amazon",
    :name     => "unknown",
    :location => "unknown"
  } # defined in ManagerRefresh::InventoryCollection::Builder::Shared#vms
}
```

## Conclusion

```add_collection()``` method is the way how to define `InventoryCollection` objects and add them to Persister.
It simplifies definitions using several IC Builders and its common definitions.  
Basic properties, like model class and its attributes can be derived automatically by name of persister's class and builder's class.  

Persister's methods ```has_inventory()``` and ```add_inventory_collection()``` are *deprecated* now.

