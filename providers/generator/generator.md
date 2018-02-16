
## Scaffolding

Use the provider generator to create a dummy provider named as `AwesomeCloud` with a cloud manager
```
cd manageiq
bundle exec rails generate provider awesome_cloud --dummy
```

You will see the console emitting the progress

```
      create
      create  .codeclimate.yml
      ...      
      insert  /Users/jwong/ws/manageiq/lib/workers/miq_worker_typ
```

### Output of scaffolding
 
* Newly created folder`plugins/manageiq-providers-awesome_cloud`
* Modified `Gemfile`

  * The following lines are added

    ```
    group :awesome_cloud, :manageiq_default do
      manageiq_plugin "manageiq-providers-awesome_cloud" # TODO: Sort alphabetically...
    end
    ```
   * During active development, you can replace the second line with
   
     `gem 'manageiq-providers-awesome_cloud', :path => 'plugins/manageiq-providers-awesome_cloud'`

* Modified `lib/workers/miq_worker_types.rb`
    * The following lines are added
 
        ```
         "ManageIQ::Providers::AwesomeCloud::CloudManager::EventCatcher"                  => %i(manageiq_default),
         "ManageIQ::Providers::AwesomeCloud::CloudManager::MetricsCollectorWorker"        => %i(manageiq_default),
         "ManageIQ::Providers::AwesomeCloud::CloudManager::RefreshWorker"                 => %i(manageiq_default),
        ```

Now run `bundle install` to activate the new provider `awesome_cloud` plugin

### Create an AwesomeCloud instance 

Start rails console by executing `bundle exec rails c` and perform the following in the rails console
1. Create the cloud manager
    ```
     ems = ManageIQ::Providers::AwesomeCloud::CloudManager.new(:name => 'CloudAwesome', :zone => Zone.default_zone) 
     ems.save!
    ```
1. Create an authentication and associate it with the new manager
    ```
     auth = Authentication.new(:name => 'Awww', :userid=> 'admin', :password => 'secrets')
     auth.resource = ems # associated
     auth.save!
    ```

## Notes

* The dummy cloud manager comes with 2 dummy instances.
* The code generated is similar to this [dummy provider repo](https://github.com/jameswnl/manageiq-providers-dummy_provider)
