ManageIQ API (Developer Guide)
==============================

This is a developer guide for navigating the `manageiq-api` repo, and how to
understand the codebase to make additions and fixes yourself.  This guide will
not go in depth into the functionality of each resource, but rather explain
common functionality across all controllers to allow you to determine nuances
on a per-resource basis for yourself.

A good introduction (that I found after writing almost half of this...) was
written by Jillian Tullo:

http://manageiq.org/blog/2017/10/api-contributors-guide/

And is a great overview of what is talked about this guide.

That said, this is also meant to be a living document, not a point in time
reference, so there at least should still be some value in this (I hope...
:sob:)


Table of Contents
-----------------

* [The `base_controller.rb`](#the-base_controllerrb)
  - [The Basics](#the-basics)
  - [Overriding base functionality](#overriding-base-functionality)
  - [The `RequestAdapter`](#the-requestadapter)
* [ApiConfig](#apiconfig)
  - [The `config/api.yml`](#the-configapiyml)
    - [`:options:`](#options)
      - [Collections and Subcollections](#collections-and-subcollections)
      - [Validate Action](#validate-action-validate_action)
      - [Custom Actions](#custom-actions-custom_actions)
  - [Drawing Routes (the `config/routes.rb`)](#drawing-routes-the-configroutesrb)
* [The `manageiq-api-client` gem](#the-manageiq-api-client-gem)


The `base_controller.rb`
------------------------

- Most Controllers inherit from this controller
- Updating resource options

The first part of `manageiq-api` codebase that you should familiarize yourself
with is the [`app/controllers/api/base_controller.rb`][1] class, and included
modules in it's associated directory.  Almost all (if not all), controllers in
the API inherit from this controller, and the entry point for each action
defined in the routes (more on that in a later section), are defined in this
class


### The Basics

If you are familiar with a typical Rails controller, most of the
methods/actions you are used to seeing are there:

- `index`
- `show`
- `create`
- `update`
- `destroy`

And so on, but most of these calls are inherited and never modified.  So for
example, the controller for accessing all of the `MiqServer` records in an
installation of ManageIQ is defined in the `Api::ServersController`:

[`app/controllers/api/servers_controller.rb`][2]

But, that class itself is basically empty:

```ruby
module Api
  class ServersController < BaseController
  end
end
```

This is because it uses, without modifications, the code from the
`Api::BaseController`.  Now this is basic inheritance, so there is nothing
interesting here of note, accept for the fact that not every method defined in
the `Api::BaseController` is available as a route in the
`Api::ServersController`:

```console
$ bin/rake routes -c Api::ServersController
             Prefix Verb             URI Pattern                                      Controller#Action
                    OPTIONS          /api(/:version)/servers(.:format)                api/servers#options {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
        api_servers GET              /api(/:version)/servers(.:format)                api/servers#index {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
         api_server GET              /api(/:version)/servers/:c_id(.:format)          api/servers#show {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
api_server_settings GET|PATCH|DELETE /api(/:version)/servers/:c_id/settings(.:format) api/servers#settings {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
```

Compared to something like the `Api::TenantsController`:

```console
$ bin/rake routes -c Api::TenantsController
           Prefix Verb    URI Pattern                                            Controller#Action
                  OPTIONS /api(/:version)/tenants(.:format)                      api/tenants#options {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
      api_tenants GET     /api(/:version)/tenants(.:format)                      api/tenants#index {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
       api_tenant GET     /api(/:version)/tenants/:c_id(.:format)                api/tenants#show {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
                  PUT     /api(/:version)/tenants/:c_id(.:format)                api/tenants#update {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
                  POST    /api(/:version)/tenants(.:format)                      api/tenants#create {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
                  POST    /api(/:version)/tenants(/:c_id)(.:format)              api/tenants#update {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
                  PATCH   /api(/:version)/tenants/:c_id(.:format)                api/tenants#update {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
                  DELETE  /api(/:version)/tenants/:c_id(.:format)                api/tenants#destroy {:format=>"json", :version=>/v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/}
<...>
```

but that is more of a topic for the `ApiConfig`, which is part of the next
section. 


### Overriding base functionality  

The [`Api::TenantsController`][3] though is a little more interesting to look
at, and covers the next topic of overriding functionality in the
`Api::BaseController`.

The first thing you will notice in this file is that we are not overriding any
of our top level methods that we would expect (`index`, `update`, etc.), but
two methods that are not attached to any routes directly:

- [`Api::TenantsController#create_resource`][4]
- [`Api::TenantsController#edit_resource`][5]

In both of these methods, they are making use of specialized methods to
validate that there are no bad attributes passed that the API doesn't support,
and parsing out parent.

Most of the times that the `*_resource` actions are overwritten, they usually
will default back to calling `super`, but in the case of `create_resource` for
the `Api::TenantsController`, it has simply called a `Tenant.create` to avoid
going through the arg parsing defined in `Api::BaseController#create_resource`.


### The `RequestAdapter`

The code for this is actually located in [`lib/api/request_adapter.rb`][6], but this
is instantiated as part of every request via the `before_action` of all
requests and defined in [`Api::BaseController::Parser#parse_api_request`][7].
This instance can be accessed via the instance variable `@req`, and will be
found and used throughout the `manageiq-api` codebase and is used as a shared
interface for accessing standardized portions of the api request object.

Also associated with this class is the `Api::Href`, which is associated with
each `RequestAdapter`, and parses each API request's url to determine what
resource should be processed, the id associated with it (if any), what is the
top level resource and subcollections, etc.


The `ApiConfig`
---------------

_TODO_

Configures:

- available routes
- available collections/subcollections
- hooked into `config/routes.rb`

### The `config/api.yml`

#### `:options:`

These are shared identifiers in the `ApiConfig` to denote specific shared rules
that modify the behavior of the actions.

##### Collections and Subcollections

_TODO_

##### Validate Action (`:validate_action`)

This flag is used relatively sparsely, but when sending back the json response
for an object, the metadata for the object showing the hypermedia (TODO:  is
"hypermedia" the correct term?) for the resource will check actions with this
option and call the `validate_[action_name]` before adding them to the
hypermedia list of valid actions.

These specifically call methods on the model instances themselves (found in the
ManageIQ/manageiq repo) to see if they have the valid attributes or conditions
necessary to execute the action being rendered.  These are usually custom
actions outside of the typical `CRUD` operations like `show`, `update`, etc.

`Api::Services#reconfigure` is an example of this, and when rendering the
result for `Api::Services#show`, it will check the object to see if it both
`.respond_to?(:validate_reconfigure)`, and the result of the method is `true`.
If it does not respond to this method, or false is returned, the action is not
displayed in the hypermedia of the response.

##### Custom Actions (`:custom_actions`)

{{{TODO:  Flesh out}}}  Actions that can be called as part of the POST
interface using `:action` in the param.  This is a way for defining conditional
actions for a specific resource in the DB without giving it a direct route to
call.  Custom buttons attached to VMs are an example of this in practice.


The `manageiq-api-client` gem
-----------------------------

_TODO_

* Initialization: Pulls actions and resources from the API
* ActiveRecord Like



[1]: https://github.com/ManageIQ/manageiq-api/blob/97eea82/app/controllers/api/base_controller.rb
[2]: https://github.com/ManageIQ/manageiq-api/blob/97eea82/app/controllers/api/servers_controller.rb
[3]: https://github.com/ManageIQ/manageiq-api/blob/97eea82/app/controllers/api/tenants_controller.rb
[4]: https://github.com/ManageIQ/manageiq-api/blob/97eea82/app/controllers/api/tenants_controller.rb#L8-L20
[5]: https://github.com/ManageIQ/manageiq-api/blob/97eea82/app/controllers/api/tenants_controller.rb#L22-L29
[6]: https://github.com/ManageIQ/manageiq-api/blob/97eea82/lib/api/request_adapter.rb
[7]: https://github.com/ManageIQ/manageiq-api/blob/97eea82/app/controllers/api/base_controller/parser.rb#L4-L6
