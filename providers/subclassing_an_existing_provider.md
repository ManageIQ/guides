## Subclassing an existing provider

We have already covered creating a new provider from scratch in [Creating a new provider](writing_a_new_provider.md), however it is also common for a provider to use the API from another.  For example there are a number of Cloud Services which host Kubernetes and expose the standard k8s API with different authentication.  The Openstack API is also an industry standard for private clouds and is widely implemented by other providers.

In the case where the existing provider API is already a part of ManageIQ it is possible to "subclass" the existing provider plugin and only implement the differences or possibly just provide a more specific name and logo that users will recognize.

For our example here we are going to add an on-premise version of our existing AwesomeCloud from [Creating a new provider](writing_a_new_provider.md), called AwesomePrivateCloud.  This is going to have an OpenStack compatible API but we are going to make some minor changes to the available options, taking advantage of the fact that we have a specific provider plugin.

### Creating the new plugin

First step is to create a new empty plugin:
```bash
$ bundle exec rails generate manageiq:provider ManageIQ::Providers::AwesomePrivateCloud --no-scaffolding --vcr
** ManageIQ master, codename: Oparin
      create  
         run  git init /home/grare/adam/src/manageiq/manageiq/plugins/manageiq-providers-awesome_private_cloud from "."

Initialized empty Git repository in /home/grare/adam/src/manageiq/manageiq/plugins/manageiq-providers-awesome_private_cloud/.git/
      create  manageiq-providers-awesome_private_cloud.gemspec
      create  .codeclimate.yml
      create  .gitignore
      create  .rspec
      create  .rspec_ci
      create  .rubocop.yml
      create  .rubocop_cc.yml
      create  .rubocop_local.yml
      create  .whitesource
      create  .yamllint
      create  Gemfile
      create  LICENSE.txt
      create  Rakefile
      create  README.md
      create  bin/ci/after_script
      create  bin/rails
      create  bin/setup
      create  bin/update
      create  bundler.d
      create  bundler.d/.keep
      create  config/secrets.defaults.yml
      create  config/settings.yml
      create  lib/manageiq-providers-awesome_private_cloud.rb
      create  lib/manageiq/providers/awesome_private_cloud/engine.rb
      create  lib/manageiq/providers/awesome_private_cloud/version.rb
      create  lib/tasks/README.md
      create  lib/tasks_private/spec.rake
      create  locale
      create  locale/.keep
      create  spec/factories
      create  spec/support
      create  spec/spec_helper.rb
      insert  /home/grare/adam/src/manageiq/manageiq/Gemfile
      create  spec/models/manageiq/providers/awesome_private_cloud
        gsub  lib/tasks_private/spec.rake
      insert  .yamllint
      append  spec/spec_helper.rb

```

Follow the steps from [Creating a new provider](writing_a_new_provider.md) for setting up your new plugin for local development by adding to your `bundler.d/override.rb` and symlinking your `spec/manageiq` directory.

You'll notice however that we chose "--no-scaffolding" option, this is going to allow us to define the classes that we need as subclasses of the OpenStack provider.

### Creating the subclasses

Now that we have an empty plugin we have to start adding the subclasses that we need for the provider to work.

First let's create the initial directories that will hold our subclasses:
```bash
$ mkdir -p app/models/manageiq/providers/awesome_private_cloud/{cloud_manager,network_manager,storage_manager} app/models/manageiq/providers/awesome_private_cloud/inventory/{collector,parser,persister}
```

Now we can start defining our main manager class that will inherit from OpenStack:
```ruby
ManageIQ::Providers::Openstack::CloudManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::AwesomePrivateCloud::CloudManager < ManageIQ::Providers::Openstack::CloudManager
  require_nested :RefreshWorker

  supports :create

  def self.vm_vendor
    "awesome_private_cloud"
  end

  def self.ems_type
    @ems_type ||= "awesome_private_cloud".freeze
  end

  def self.description
    @description ||= "Awesome Private Cloud".freeze
  end

  has_one :network_manager,
          :foreign_key => :parent_ems_id,
          :class_name  => "ManageIQ::Providers::AwesomePrivateCloud::NetworkManager",
          :autosave    => true,
          :dependent   => :destroy
  has_one :cinder_manager,
          :foreign_key => :parent_ems_id,
          :class_name  => "ManageIQ::Providers::AwesomePrivateCloud::StorageManager::CinderManager",
          :dependent   => :destroy,
          :inverse_of  => :parent_manager,
          :autosave    => true

  def image_name
    "awesome_private_cloud"
  end

  def ensure_swift_manager
    false
  end
end
```

This introduces the concept of `ActsAsStiLeafClass` which is critical to how a subclassed provider works.  If you don't already understand how Single-Table Inheritance (STI) works, here is a quick primer.

### Single-Table Inheritance and ActsAsStiLeafClass

STI allows for class hierarchies to be persisted to the database by way of storing the class name in the `:type` column.  See https://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html for the official docs on ActiveRecord Inheritance.

STI is heavily used in ManageIQ for provider inventory as it allows for provider plugins to implement things like operations in their own subclasses.

Where this becomes an issue for us here is how STI does queries, let's look at the SQL that is generated for a simple subclass query:
```ruby
>> ManageIQ::Providers::CloudManager::Vm.all.to_sql
=> "SELECT \"vms\".* FROM \"vms\" WHERE \"vms\".\"type\" IN ('ManageIQ::Providers::CloudManager::Vm', 'ManageIQ::Providers::Amazon::CloudManager::Vm', 'ManageIQ::Providers::Azure::CloudManager::Vm', 'ManageIQ::Providers::AzureStack::CloudManager::Vm', 'ManageIQ::Providers::Google::CloudManager::Vm', 'ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm', 'ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm', 'ManageIQ::Providers::Openstack::CloudManager::Vm', 'ManageIQ::Providers::IbmCic::CloudManager::Vm', 'ManageIQ::Providers::IbmPowerVc::CloudManager::Vm', 'ManageIQ::Providers::OracleCloud::CloudManager::Vm', 'ManageIQ::Providers::Vmware::CloudManager::Vm') AND \"vms\".\"template\" = FALSE"
```

By looking for all CloudManager VMs we expect to exclude other types of VMs such as InfraManager ones.  You can see that ActiveRecord accomplishes this by building a query that selects on a number class names.  The list of classes is determined from the descendants of the class we're checking:
```ruby
>> ManageIQ::Providers::CloudManager::Vm.descendants.map(&:name)
=> ["ManageIQ::Providers::Amazon::CloudManager::Vm", "ManageIQ::Providers::Azure::CloudManager::Vm", "ManageIQ::Providers::AzureStack::CloudManager::Vm", "ManageIQ::Providers::Google::CloudManager::Vm", "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm", "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm", "ManageIQ::Providers::Openstack::CloudManager::Vm", "ManageIQ::Providers::IbmCic::CloudManager::Vm", "ManageIQ::Providers::IbmPowerVc::CloudManager::Vm", "ManageIQ::Providers::OracleCloud::CloudManager::Vm", "ManageIQ::Providers::Vmware::CloudManager::Vm"]
```

This is exactly what we want in most cases, however if we're subclassing another provider such as `ManageIQ::Providers::Openstack::CloudManager::Vm`, if we do `ManageIQ::Providers::Openstack::CloudManager::Vm.all` we will accidentally retrieve all OpenStack VMs _and_ all subclassed provider VMs.

This is where `ActsAsStiLeafClass` comes in.  It overrides the `type_condition` method which typically does `sti_names  = ([self] + descendants).map(&:sti_name)` to get a list of types, and replaces it with just `[sti_name]`.

### Creating the subclasses

After that little detour we can get back to creating our provider.  The summary here is that any class which is a subclass of ActiveRecord::Base must include `Class.include(ActsAsStiLeafClass)`.

So if we go back to our base provider (OpenStack) we need to find each `ActiveRecord::Base` subclass and create a corresponding subclass in our provider.

Go through the OpenStack cloud_manager/* and for each `ActiveRecord::Base` subclass create a file like the following:
```ruby
ManageIQ::Providers::Openstack::CloudManager::AuthKeyPair.include(ActsAsStiLeafClass)

class ManageIQ::Providers::AwesomePrivateCloud::CloudManager::AuthKeyPair < ManageIQ::Providers::Openstack::CloudManager::AuthKeyPair
end
```
Followed by a `require_nested :AuthKeyPair` in `ManageIQ::Providers::AwesomePrivateCloud::CloudManager`.

Rinse and repeat until, in this example, you have:
```
ManageIQ::Providers::Openstack::CloudManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::AwesomePrivateCloud::CloudManager < ManageIQ::Providers::Openstack::CloudManager
  require_nested :AuthKeyPair
  require_nested :AvailabilityZone
  require_nested :AvailabilityZoneNull
  require_nested :CloudResourceQuota
  require_nested :CloudTenant
  require_nested :EventCatcher
  require_nested :Flavor
  require_nested :HostAggregate
  require_nested :MetricsCapture
  require_nested :MetricsCollectorWorker
  require_nested :OrchestrationStack
  require_nested :RefreshWorker
  require_nested :Template
  require_nested :Vm
```

Now repeat the process for the `NetworkManager` and `StorageManager::CinderManager`

Lastly create subclasses of all of the `inventory/persister/*` classes so that we are able to auto-detect the correct STI type names during refresh.  These are not ActiveRecord classes so simply:
```ruby
class ManageIQ::Providers::AwesomePrivateCloud::Inventory::Persister::CloudManager < ManageIQ::Providers::Openstack::Inventory::Persister::CloudManager
end
```
is all you need.

You should be able to run a refresh now without any more code for collection or parsing.

```ruby
>> ManageIQ::Providers::AwesomePrivateCloud::CloudManager.first.refresh
=> {ManageIQ::Providers::AwesomePrivateCloud::CloudManager::Refresher=>[#<ManageIQ::Providers::AwesomePrivateCloud::CloudManager id: 12...
```

Now that you have refresh working against a live provider it is time to write some spec tests.

There are already spec tests in core which check a number of common provider concerns that you can run with
```bash
bundle exec rake app:test:providers_common
```

Next look into writing VCR based refresh spec tests covered in depth here [Writing VCR Provider Spec Tests](writing_vcr_specs.md)
