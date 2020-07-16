## Plugins

ManageIQ is architected to be a highly extensible platform, able to be customized both by end users as well as developers.
The primary means of customization by developers is the plugin system.

### What is a plugin?

A ManageIQ plugin is simply a [Rails Engine](http://guides.rubyonrails.org/engines.html) which allows for extensive modifications to the main Rails application.  An engine can bring new models, controllers, views, etc...

Plugins can even bring their own UI (e.g.: [V2V](https://github.com/ManageIQ/manageiq-v2v/tree/master/app/javascript)) or their own API (e.g. [GraphQL](https://github.com/ManageIQ/manageiq-graphql/tree/master/app/controllers/manageiq/graphql)).

Plugins can also extend existing core properties, subclassing an STI model is a common example of this.

In addition to anything that a rails engine can bring, MIQ also loads the following from registered plugins:
* Ansible Content (`plugin-dir/content/ansible`)
* Ansible Runner Content (`plugin-dir/content/ansible_runner`)
* Automate Domains (`plugin-dir/content/automate`)
* Locales (`plugin-dir/config/supported_locales.yml`)
* Permissions (`plugin-dir/config/permissions.yml`)
* Inflections (`plugin-dir/config/initializers/inflections.rb`)
* Settings (`plugin-dir/config/settings.yml`)

### How about a provider?  Is that something different?

A provider is a special type of plugin which specializes in interfacing with External Management Systems such as Amazon AWS and VMware vSphere.  They use the functionality that the plugin system brings to allow MIQ to interface with a wide variety of other systems while maintaining a consistent set of core models.

This allows the "Single Pane of Glass" view across multiple types of providers, e.g. VMs from Amazon and Azure can be shown on the same page and automation written against the Vm model can work for both types of VMs.

### Are there any restrictions?

The single biggest restriction that MIQ imposes on plugins is that they cannot bring schema changes to the primary database.  This is done to ensure consistent modeling across all plugins and ensure that database schema is consolidated in a single place.  No hunting for what repository someone deleted a column in or created a table.
