## Creating a new provider

So your company started using this awesome new cloud platform, Awesome Cloud.  You use ManageIQ for your automation but there isn't a provider for Awesome Cloud...what to do?

Well luckily writing your own MIQ Provider is easy!  Let's walk through creating a new cloud provider from scratch together.

### Generate the scaffolding

The first step in building a new provider is to create the plugin directory and the scaffolding.  ManageIQ has a built-in provider generator for just this purpose.

If you haven't yet setup your core repository go through the [developer setup](../developer_setup.md) guide.  After this you should have your own copy of [manageiq](https://github.com/ManageIQ/manageiq) ready to go.

From this local clone we can run the provider generator, first lets take a look at the help

```bash
$ bundle exec rails generate manageiq:provider --help
Usage:
  rails generate manageiq:provider NAME [options]

Options:
  [--path=PATH]                        # Create plugin at given path
                                       # Default: plugins
  [--js], [--no-js]                    # Enable JavaScript in the plugin
  [--vcr], [--no-vcr]                  # Enable VCR cassettes (Default: --no-vcr)
  [--scaffolding], [--no-scaffolding]  # Generate default class scaffolding (Default: --scaffolding)
                                       # Default: true
  [--manager-type=MANAGER_TYPE]        # What type of manager to create, required if building scaffolding (Options: automation, cloud, configuration, container, infra, monitoring, network, physical, provisioning, storage)

Runtime options:
  -f, [--force]                    # Overwrite files that already exist
  -p, [--pretend], [--no-pretend]  # Run but do not make any changes
  -q, [--quiet], [--no-quiet]      # Suppress status output
  -s, [--skip], [--no-skip]        # Skip files that already exist

Description:
    Create or update ManageIQ provider plugin

Example:
    rails generate manageiq:provider ManageIQ::Providers::VendorName --manager-type=cloud
    rails generate manageiq:provider ManageIQ::Providers::VendorName --manager-type=cloud --path ~/dev
    rails generate manageiq:provider ManageIQ::Providers::VendorName --manager-type=cloud --vcr
    rails generate manageiq:provider ManageIQ::Providers::VendorName --manager-type=cloud --vcr --js
    rails generate manageiq:provider ManageIQ::Providers::VendorName --no-scaffolding
```

For our purposes here we're going to want to create a `CloudManager` with VCR support, provider specific JavaScript, and scaffolding.

So lets go ahead and create our provider plugin:
```bash
$ bundle exec rails generate manageiq:provider ManageIQ::Providers::AwesomeCloud --manager-type=cloud --vcr --js --scaffolding

create  
   run  git init /home/grare/adam/src/manageiq/manageiq/plugins/manageiq-providers-awesome_cloud from "."
Initialized empty Git repository in /home/grare/adam/src/manageiq/manageiq/plugins/manageiq-providers-awesome_cloud/.git/
create  manageiq-providers-awesome_cloud.gemspec
create  .codeclimate.yml
create  .gitignore
create  .rspec
create  .rspec_ci
create  .rubocop.yml
create  .rubocop_cc.yml
create  .rubocop_local.yml
create  .travis.yml
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
create  config/settings.yml
create  lib/manageiq-providers-awesome_cloud.rb
create  lib/manageiq/providers/awesome_cloud/engine.rb
create  lib/manageiq/providers/awesome_cloud/version.rb
create  lib/tasks/README.md
create  lib/tasks_private/spec.rake
create  locale
create  locale/.keep
create  spec/factories
create  spec/support
create  spec/spec_helper.rb
insert  .gitignore
create  .yarnrc.yml
create  .yarn/releases/yarn-3.0.2.cjs
create  package.json
create  yarn.lock
insert  /home/grare/adam/src/manageiq/manageiq/Gemfile
create  spec/models/manageiq/providers/awesome_cloud
  gsub  lib/tasks_private/spec.rake
create  systemd/manageiq-providers-awesome_cloud_cloud_manager_event_catcher@.service
create  systemd/manageiq-providers-awesome_cloud_cloud_manager_event_catcher.target
create  systemd/manageiq-providers-awesome_cloud_cloud_manager_refresh@.service
create  systemd/manageiq-providers-awesome_cloud_cloud_manager_refresh.target
create  systemd/manageiq-providers-awesome_cloud_cloud_manager_metrics_collector@.service
create  systemd/manageiq-providers-awesome_cloud_cloud_manager_metrics_collector.target
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/event_catcher/runner.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/event_catcher/stream.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/metrics_collector_worker/runner.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/refresh_worker/runner.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/event_catcher.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/metrics_capture.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/metrics_collector_worker.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/refresh_worker.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/refresher.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager/vm.rb
create  app/models/manageiq/providers/awesome_cloud/inventory.rb
create  app/models/manageiq/providers/awesome_cloud/inventory/collector.rb
create  app/models/manageiq/providers/awesome_cloud/inventory/parser.rb
create  app/models/manageiq/providers/awesome_cloud/inventory/persister.rb
create  app/models/manageiq/providers/awesome_cloud/inventory/collector/cloud_manager.rb
create  app/models/manageiq/providers/awesome_cloud/inventory/parser/cloud_manager.rb
create  app/models/manageiq/providers/awesome_cloud/inventory/persister/definitions/cloud_collections.rb
create  app/models/manageiq/providers/awesome_cloud/inventory/persister/cloud_manager.rb
identical  app/models/manageiq/providers/awesome_cloud/inventory/persister.rb
create  app/models/manageiq/providers/awesome_cloud/cloud_manager.rb
insert  .yamllint
append  spec/spec_helper.rb
```

That's a lot of stuff!  We'll cover all of it in detail later but for now lets take a look at our plugin:

```bash
$ ls plugins/
manageiq-providers-awesome_cloud
```

The generator also automatically adds your plugin to your local Gemfile:

```bash
$ git diff
diff --git a/Gemfile b/Gemfile
index b7e6783821..685474c570 100644
--- a/Gemfile
+++ b/Gemfile
 # This default is used to automatically require all of our gems in processes that don't specify which bundler groups they want.
 #
 ### providers
+
+group :awesome_cloud, :manageiq_default do
+  manageiq_plugin "manageiq-providers-awesome_cloud"
+end
+
```

This is a bit optimistic since this hasn't been accepted into the ManageIQ organization yet. :)

To work on this plugin locally you have to tell bundler to look in a different place for your gem (more info in [developer_setup/plugins.md](../developer_setup/plugins.md))

```bash
$ echo 'override_gem "manageiq-providers-awesome_cloud", :path => "../plugins/manageiq-providers-awesome_cloud"' >> bundler.d/override.rb
$ bundle update
```

This tells your core repo where to find your local changes, now lets let your plugin know where your local core repo is:
```bash
$ ln -s $(pwd) plugins/manageiq-providers-awesome_cloud/spec/manageiq
$ cd plugins/manageiq-providers-awesome_cloud
$ bin/setup
```

Lets also take this opportunity to commit the initial code built by the generator before we make any changes:
```bash
$ git add .
$ git commit  -m "Initial commit"
```

Now that we have both sides linked up lets verify that everything worked:
```ruby
$ bundle exec rails c
>> ManageIQ::Providers::AwesomeCloud
=> ManageIQ::Providers::AwesomeCloud
>> ManageIQ::Providers::AwesomeCloud::CloudManager
=> ManageIQ::Providers::AwesomeCloud::CloudManager (call 'ManageIQ::Providers::AwesomeCloud::CloudManager.connection' to establish a connection)
```

Success!  That means that core ManageIQ knows about our new cloud provider.

Now lets get that provider added so we have something to play with:
```ruby
>> ems = ManageIQ::Providers::AwesomeCloud::CloudManager.create!(:name => "My Awesome Cloud", :zone => Zone.default_zone)
```

Now that we have that done it is time to start filling out our new provider.  The first step is to find the SDK gem for this provider.  If there isn't a provider SDK for Ruby you have a few options which we'll cover later.  For now lets assume that Awesome Cloud has a ruby gem called 'awesome_cloud'.

### Add your provider's SDK to the gemspec

Let's add this to our provider's gemspec:
```bash
$ git diff
diff --git a/manageiq-providers-awesome_cloud.gemspec b/manageiq-providers-awesome_cloud.gemspec
index 6c228c2..91e8e71 100644
--- a/manageiq-providers-awesome_cloud.gemspec
+++ b/manageiq-providers-awesome_cloud.gemspec
@@ -18,6 +18,8 @@ Gem::Specification.new do |spec|
   spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
   spec.require_paths = ["lib"]

+  spec.add_dependency "awesome_cloud", "~> 0.1"
+
   spec.add_development_dependency "manageiq-style"
   spec.add_development_dependency "simplecov"
```

Then bundle update to pull in the change
```
$ bundle update
```

Now that we have the gem installed we can start to write our connection code.  ManageIQ providers have to expose a `#connect` and a `#verify_credentials` method on the class and the instance.  The class method is used when adding a provider (when there is no instance record yet) and the instance methods are used after.

Let's assume that Awesome Cloud requires a region, access_key, and secret_key in order to connect.

```ruby
>> ems = ManageIQ::Providers::AwesomeCloud::CloudManager.first
>> ems.update!(:provider_region => "us-east-1")
>> ems.update_authentication(:default => {:userid => "MY-ACCESS-KEY", :password => "MY-SECRET-KEY"})
```

Now let's add connect methods to our provider.

### Connecting and verifying credentials

```ruby
class ManageIQ::Providers::AwesomeCloud::CloudManager < ManageIQ::Providers::CloudManager
  def self.raw_connect(region, access_key, secret_key, service = "Compute")
    require "awesome_cloud"

    AwesomeCloud::Client.new(:access_key => access_key, :secret_key => secret_key, :region => region, :service => service)
  end

  def self.verify_credentials(args)
    # NOTE this args hash has a very specific format that we'll get to next
    region = args["provider_region"]
    default_endpoint = args.dig("authentications", "default")
    access_key, secret_key = default_endpoint&.values_at("userid", "password")

    validate_connection(raw_connect(region, access_key, secret_key))
  end

  # NOTE: You want to use the same method for validating credentials at the
  # class-level and instance-level.  This prevents any potential issues were
  # adding a new provider (class-level) might pass verification but after adding
  # it (instance-lavel) it fails.
  def self.validate_connection(connection)
    # Perform a simple and fast operation that verifies the credentials are correct
    !!connection.list_regions
  end

  def connect(type: "default", service: "Compute")
    access_key, secret_key = auth_user_pwd(type)
    self.class.raw_connect(provider_region, access_key, secret_key, service)
  end

  def verify_credentials(type = "default", options = {})
    with_provider_connection(:type => type) do |connection|
      self.class.validate_connection(connection)
    rescue AwesomeCloud::Error => err
      raise MiqException::MiqInvalidCredentialsError, "Invalid credentials: #{err}"
    end
  end
end
```

With these in place we should be able to test our provider that we added to MIQ:

```ruby
>> ems = ManageIQ::Providers::AwesomeCloud::CloudManager.first
>> ems.authentication_check
=> [true, ""]
>> ems.connect(:service => "Compute").list_regions
```

### Adding your provider from the UI

Creating the provider record from a rails console is great for developers but it is much nicer to be able to do this from the UI.  ManageIQ has a very simple way of telling the UI what your provider needs to be able to be added via the UI, [Data-Driven-Forms](https://data-driven-forms.org/).

You basically define what forms you need in a hash in your provider plugin and the ManageIQ UI will display it for you.  If you want a good introduction check out https://data-driven-forms.org/introduction.  For now we'll just create a basic form that takes a provider region, access key, and secret key.

```ruby
class ManageIQ::Providers::AwesomeCloud::CloudManager < ManageIQ::Providers::CloudManager
  def self.params_for_create
    {
      :fields => [
        {
          :component    => "select",
          :id           => "provider_region",
          :name         => "provider_region",
          :label        => _("Region"),
          :isRequired   => true,
          :validate     => [{:type => "required"}],
          :includeEmpty => true,
          :options      => provider_region_options
        },
        {
          :component => 'sub-form',
          :name      => 'endpoints-subform',
          :id        => 'endpoints-subform',
          :title     => _("Endpoints"),
          :fields    => [
            {
              :component              => 'validate-provider-credentials',
              :id                     => 'authentications.default.valid',
              :name                   => 'authentications.default.valid',
              :skipSubmit             => true,
              :isRequired             => true,
              :validationDependencies => %w[type zone_id provider_region uid_ems],
              :fields                 => [
                {
                  :component  => "text-field",
                  :id         => "authentications.default.userid",
                  :name       => "authentications.default.userid",
                  :label      => _("Access Key"),
                  :isRequired => true,
                  :validate   => [{:type => "required"}]
                },
                {
                  :component      => "password-field",
                  :rows           => 10,
                  :id             => "authentications.default.password",
                  :name           => "authentications.default.password",
                  :label          => _("Secret Key"),
                  :type           => "password",
                  :isRequired     => true,
                  :validate       => [{:type => "required"}]
                },
              ]
            }
          ]
        }
      ]
    }
  end

  private_class_method def self.provider_region_options
    ManageIQ::Providers::AwesomeCloud::Regions.all.map { |region| {:label => region[:name], :value => region[:name]} }
  end

  supports :regions
  validates :provider_region, :inclusion => {:in => ManageIQ::Providers::AwesomeCloud::Regions.names}
end
```

```
module ManageIQ::Providers::AwesomeCloud::Regions
  REGIONS = {
    "us-east-1" => {:name => "us-east-1", :hostname => "us-east-1.awesome.cloud"}
  }.freeze

  def self.regions
    REGIONS
  end

  def self.all
    regions.values
  end

  def self.names
    regions.keys
  end
end
```

With that added you should be able to go to the UI, add a cloud provider, and see your new cloud type.  For development typically the best way to test code in the UI is to run a rails server and a simulated generic worker via the terminal.

To do this open two terminals, in the first one run `bundle exec rails s` and in the second run `bundle exec rails console` and typing `simulate_queue_worker`.  Now you can open `localhost:3000` in your browser of choice and you should be able to login.

### Inventory Refresh

Up to this point our provider doesn't do a lot, we've simply been setting the groundwork for the future.

Inventory Refresh/Discovery is the first significant feature that we'll be adding.  This process is what synchronizes the cloud inventory (instances, volumes, flavors, images, etc...) with the ManageIQ database (VMDB).  This allows MIQ to show inventory on the UI, expose actions on that inventory, run reports, collect metrics, etc...

Almost every MIQ feature starts out with provider inventory, so lets get started.

Refresh is split up into three main parts: Collection, Parsing, and Persisting.

1. Inventory Collection - This is the step where you use the connection to hit the provider API to pull down inventory.  The code for this will be under `app/models/manageiq/providers/awesome_cloud/inventory/collector.rb`

2. Parsing - This is typically the bulk of the inventory refresh code.  This step translates the inventory data from the native format into the ManageIQ schema.  This code lives in `app/models/manageiq/providers/awesome_cloud/inventory/parser.rb`

3. Persisting - In this step the parsed data is saved to the database.  Almost all of this is offloaded to core classes but as a provider author you are responsible for enumerating the "inventory collections" that you'll be saving e.g. flavors/vms/disks.  This will live in `app/models/manageiq/providers/awesome_cloud/inventory/persister.rb`

For a more in depth overview of how refresh works check out the [Refresh Documentation](refresh.md)

For now lets cover a very simple refresh case, collecting flavors, instances, and images.

First let's declare the collections that we intend to use.  The full set of possible collections can be found in core's `Inventory::Persister::Builder` sub-classes.

```ruby
class ManageIQ::Providers::AwesomeCloud::Inventory::Persister < ManageIQ::Providers::Inventory::Persister
  # This should already be here from the generator, you just need one empty subclass
  # for each child-manager type that your provider has (e.g. NetworkManager and/or StorageManager).
  require_nested :CloudManager

  # Add the list of inventory collections that you want to use here
  # In the future if you want to add more inventory like disks or networks you would
  # add them to the list here.
  def initialize_inventory_collections
    add_cloud_collection(:flavors)
    add_cloud_collection(:miq_templates)
    add_cloud_collection(:vms)
  end
end
```

Once those are declared ManageIQ Core will take care of actually saving everything to the database for you.

Now lets look at collecting inventory.  For that let's look at :shocked: the collector.

The collector provides an interface for the parser, so each method should fetch and return the relevant inventory.

```ruby
class ManageIQ::Providers::AwesomeCloud::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  require_nested :CloudManager

  def images
    compute_client.get_images
  end

  def instances
    compute_client.get_instances
  end

  def instance_types
    compute_client.get_instance_types
  end

  private

  def compute_client
    @compute_client ||= manager.connect(:service => "Compute")
  end
end
```

And that's it!  The collector gets a lot more interesting when you add support for targeted refresh but that is for another time.  If you have to manually handle paging you should do that here, if the sdk handles paging automatically via an Enumerator then there's nothing more needed.

Now we can get started on the parser.

```ruby
class ManageIQ::Providers::AwesomeCloud::Inventory::Parser < ManageIQ::Providers::Inventory::Parser
  require_nested :CloudManager

  def parse
    instance_types
    images
    instances
  end

  def instance_types
    # Calling collector.instance_types here is what actually issues the API call.
    collector.instance_types.each do |instance_type|
      # At this point "instance_type" will be whatever is returned by your SDK.
      # It could be a hash or it could be an object like `AwesomeCloud::Compute::InstanceType`

      # persister.flavors.build will create an InventoryObject (fancy hash) with all of the
      # attributes that you pass in here, and automatically add it to the `persister.flavors`
      # inventory collection
      persister.flavors.build(
        # MIQ uses "ems_ref" as the unique reference for an inventory item
        # in a provider.  Whatever you use must be guaranteed to not have a duplicate
        # in the same provider instance as this value is also used to lookup related
        # inventory from other collections.
        :ems_ref => instance_type.id,
        :name    => instance_type.name,
        :cpus    => instance_type.n_cpus,
        :memory  => instance_type.ram
      )
    end
  end

  def images
    collector.images.each do |image|
      persister.miq_templates.build(
        :ems_ref         => image.id,
        # The uid_ems field if you see it typically indicates a field that can be used
        # to identify an inventory item across provider instances.  Most of the time
        # for cloud providers this is the same as the ems_ref but not always.
        # If your ems_ref looks like an integer ID then it probably isn't unique.
        # If it looks like a UUID then it probably is.
        :uid_ems         => image.id,
        :name            => image.name,
        :location        => "unknown",
        :raw_power_state => "never",
        :template        => true,
        :vendor          => "awesome_cloud"
      )
    end
  end

  def instances
    collector.instances.each do |instance|
      persister_vm = persister.vms.build(
        :ems_ref         => instance.id,
        :uid_ems         => instance.id,
        :name            => instance.name,
        :location        => instance.availability_zone,
        :raw_power_state => instance.power_state,
        :vendor          => "awesome_cloud",
        # This is where things get interesting.  A "Lazy Reference" is our way of
        # declaring a relationship to another table.  The result of this lazy_find
        # after save_inventory has completed will be a foreign-key to that table
        #
        # It is critically important that you use this instead of either:
        # 1. Direct database query like: Flavor.find_by(:ems_ref => instance.flavor)
        #   because this won't work with flavors that are being created in this refresh
        # 2. Using data set in the parser like: persitser.flavors.data.detect { |f| f[:ems_ref] == instance.flavor }
        #   because this introduces an ordered dependency (flavors have to be parsed
        #   before instances) and it is possible to introduce a dependency cycle and
        #   also makes future targeted refresh much harder (where the flavors might not be
        #   present in the collected data).
        :flavor          => persister.flavors.lazy_find(instance.flavor)
      )
    end
  end
end
```

You'll have to add your vendor name to the core `VmOrTemplate` `VENDOR_TYPES` in order for the VMs to be saved.

```
class VmOrTemplate
  VENDOR_TYPES = {
    "awesome_cloud" => "Awesome Cloud",
    "unknown"       => "Unknown"
  }
end
```

Now that we have all of that hooked up lets test it!

```ruby
>> ems = ManageIQ::Providers::AwesomeCloud::CloudManager.first
>> ems.refresh
# Lots of queries
>> ems.vms.count
=> 1
>> ems.vms.first
=> #<ManageIQ::Providers::AwesomeCloud::CloudManager::Vm id: 131, vendor: "awesome_cloud", format: nil, version: nil, name: "my-first-vm", description: nil, location: "5ae243b0-a45f-4043-b59b-ddbcfd98896a",...
>> ems.vms.first.flavor.ems_ref
=> "579405c1-8867-4e78-94fd-72ff575e8d0a"
```

Congrats!  You have successfully refreshed your provider.  By default this will be automatically refreshed every 15 minutes which is the default for providers without an event catcher (more on that later).

### Next Steps

That's a very high level overview of writing a provider.  There is a lot still that you can and should do:

* Fill out what is collected for your existing collections (e.g. get availability zones and disks for VMs)
* Add more collections like cloud_volumes and cloud_tenants to your CloudManager
* Add a NetworkManager and start collecting CloudNetworks, CloudSubnets, etc...
* Add some operations like start/stop/destroy to Vms
* Add [Targeted Refresh](targeted_refresh.md) and Event and Metrics collection
* Instance Provisioning

Having VMs in inventory is a great start to using some of the other features of ManageIQ and is usually the point where we will accept a new provider into the ManageIQ organization.
