## Generators

### Plugin generator

Use the plugin generator to create a ManageIQ plugin.

For example, to create a plugin called ManageIQ::MyPlugin, do the following

```sh
cd manageiq
bundle exec rails generate manageiq:plugin ManageIQ::MyPlugin
```

This will create the directory `plugins/manageiq-my_plugin`, and you will see
the creation progress emitted to the console:

```text
create
create  .codeclimate.yml
...
```

By default, the plugin will be created in the `plugins` directory, but you can
specify an alternate directory with `--path <path>`.

#### Core modifications

In addition to creating to new plugin, the generator will also modify some core
ManageIQ files in order connect the application with the new plugin.

The following lines are added to the `Gemfile`:

```ruby
group :my_plugin, :manageiq_default do
  manageiq_plugin "manageiq-my_plugin" # TODO: Sort alphabetically...
end
```

During active development, you can replace the second line with

```ruby
gem 'manageiq-my_plugin', :path => 'plugins/manageiq-my_plugin'
```

Now you can run `bundle install` to activate the new plugin.

### Provider generator

If you are creating a provider plugin, you can use the provider generator to
emit some extra scaffolding.  The provider generator is the same as the plugin
generator but with some extra features.

For example, to create a provider plugin called ManageIQ::Providers::AwesomeCloud,
do the following:

```sh
cd manageiq
bundle exec rails generate manageiq:provider ManageIQ::Providers::AwesomeCloud --manager-type=cloud
```

Much like the plugin generator, you can pass `--path` to change the path.
Additionally, you also have the following options

* `[--vcr], [--no-vcr]      # Enable VCR cassettes (Default: --no-vcr)`

  Adds some scaffolding to support [VCR](https://github.com/vcr/vcr) recordings
  for specs.

* `[--scaffolding], [--no-scaffolding]  # Generate default class scaffolding (Default: true)`

  Adds some scaffolding for a dummy cloud provider, including implementations of
  core models and common workers. The generated scaffolding is similar to the
  [dummy provider repo](https://github.com/ManageIQ/manageiq-providers-dummy_provider).

* `[--manager-type=MANAGER_TYPE]        # What type of manager to create, required if building scaffolding`

  Indicates what type of manager to create, for example: cloud, container, infra, physical, etc...  `--help` will print the full list of possible manager types.

#### Core modifications

The following lines are added to your `Gemfile`:

```ruby
### providers

group :awesome_cloud, :manageiq_default do
  manageiq_plugin "manageiq-providers-awesome_cloud" # TODO: Sort alphabetically...
end
```

Until your plugin is pushed upstream you can override the gem for local development by adding the following to a `bundler.d/plugins.rb`:

```
override_gem "manageiq-providers-awesome_cloud", :path => "../plugins/manageiq-providers-awesome_cloud"
```

#### Create an AwesomeCloud instance

Start rails console by executing `bundle exec rails c` and perform the following
in the rails console, to create the cloud manager with an associated authentication.

```ruby
ems = ManageIQ::Providers::AwesomeCloud::CloudManager.create!(:name => 'CloudAwesome', :zone => Zone.default_zone)
ems.update_authentication(:default => {:userid => user, :password => pass})
```
