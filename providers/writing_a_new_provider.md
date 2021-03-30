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
    rails generate manageiq:provider ManageIQ::Providers::VendorName --no-scaffolding
```

For our purposes here we're going to want to create a `CloudManager` with VCR support and scaffolding.

So lets go ahead and create our provider plugin:
```bash
$ bundle exec rails generate manageiq:provider ManageIQ::Providers::AwesomeCloud --manager-type=cloud --vcr --scaffolding

create  
   run  git init /home/grare/adam/src/manageiq/manageiq/plugins/manageiq-providers-awesome_cloud from "."
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint:
hint: 	git config --global init.defaultBranch <name>
hint:
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint:
hint: 	git branch -m <name>
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
