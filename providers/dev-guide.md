
# Integration with ManageIQ
_The goal of this document is to describe how to add new features to providers but
it can also help when creating a new provider from scratch._

## Brief Summary of MiQ Architecture
ManageIQ (MiQ) targets to be a high-level manager (meta-manager), i.e. the manager of other managers. In the MiQ terminology the
child managers are called providers and their goal is to provide the information from the managed system as well
as triggering the operations on the managed system. Well, to be exact, the manager is the external system, while
the provider is that part of MiQ that talks to that manager. Adding a provider that is connecting to an external system
is then [pretty easy](http://manageiq.org/docs/get-started/add-a-provider).

The task of integration of a particular system with ManageIQ can be reduced to a task of writing the corresponding
ManageIQ provider. Because the ManageIQ is a web application written in the Ruby on Rails framework, it's quite
natural to split the task to the MVC layers.

## Developer Setup
So as not to reinvent the wheel we recommend going to the
[developer setup](https://github.com/ManageIQ/guides/blob/master/developer_setup.md) page and do all the
necessary steps. After this, you should be able to run the MiQ web application with typing `rails server` (shortly `rails s`)
or even `bundle exec rails server` which makes sure it is running in context of the current bundle (more info
[here](http://stackoverflow.com/a/6588708/1594980)). Running this command will start the Puma server that is
listening on http://localhost:3000. The default credentials for the dev setup are `admin:smartvm`.

## Data Flow
Managers are responsible to feed the data into MiQ DB during the refresh operation. In the MiQ terminology it's
feeding the MiQ inventory. This operation can be triggered explicitly from UI but it's also done automatically
each 15 minutes. Each provider is also capable of running operations.

After the Developer Setup step you should be able to run the UI server. This, however, won't spawn the worker thread
that is responsible for doing the refresh operation on providers. If you need to do also the refresh on providers,
We recommend running `rails console` (or `rails c`) in a new terminal window and typing in `simulate_queue_worker`. This command in the
rails console will do the work if you click in UI on the refresh button. If you want to run the refresh
directly from the rails console, you may want to do that with


```ruby
reload!; EmsRefresh.refresh(ExtManagementSystem.last)
```

The `reload!` in the command is not necessary if you didn't modify the code.

## Model Layer
When adding new features or writing new providers, the first step is usually to map the entities and relations by
model to the MiQ database, in order to be able to store the data from any external provider. We need to have the database tables prepared for it.

In Rails most often each entity has its own table in the database. To manage the DB changes there is a support mechanism
called migrations. Migrations allow easily migrate from one version of schema to an older one or upgrade to a new
one. So the migration scripts basically contain the described change to the schema including the creation of a new
table. They are stored in [here](https://github.com/ManageIQ/manageiq-schema/tree/master/db/migrate) and each migration
is prefixed by the time when it was created and then followed by a brief description of what it does. Rails provide
a way to scaffold them using for instance:

```bash
rails generate migration AddColumnNameToTableName column:string
```

This command should generate the properly named file with the following content:

```ruby
class AddColumnToTable < ActiveRecord::Migration[5.0] def change add_column :table_name, :column_name, :string end end
```

Scaffolding can make things faster, but often it's easier to write it from scratch for more complex scenarios.

## View Layer
For more comprehensive and more general guide we recommend going
[here](https://github.com/ManageIQ/guides/blob/master/ui/patterns.md). The MiQ application spans multiple repositories:
the core (including models) is hosted [here](https://github.com/ManageIQ/manageiq/) and the majority of the UI is
stored in the
[ui repo](https://github.com/ManageIQ/manageiq-ui-classic) (contains also all the controllers). Some angular
components are in [components repo](https://github.com/ManageIQ/ui-components) and also the providers have been refactored
out into their own repositories. 
It's important to keep in mind that when implementing a new feature that changes the backend and also the frontend,
 multiple repositories need to be addressed.

### HAML
Haml is the templating mechanism used across ManageIQ. It provides a way to write the HTML code in a yaml-like language
without the need of writing the tons of nested divs. Its format is pretty simple, for instance this piece of haml code:

```haml
#content
  .left.column
    %h2 Welcome to our site!
    %p= print_information
  .right.column
    = render :partial => "sidebar"
```

will be transformed into

```html
<div id='content'>
  <div class='left column'>
    <h2>Welcome to our site!</h2>
    <p>Output of the print_information method.</p>
  </div>
  <div class="right column">
    ... <!-- some component included as a partial -->
  </div>
</div>
```

If you prefer the plain HTML or you already have your code in HTML, you may want to use
some [conversion tools](https://html2haml.herokuapp.com/) for that. 

### Partials
Some pieces of the UI that are used in many places can be extracted into so-called partials and reused from multiple
contexts. A partial is a HAML file whose name starts with the underscore. So for instance, one can create a file called
`_sidebar.haml` and reuse this by calling `render :partial => sidebar`. Partials can also have a "slots for data"
that are passed to the render method or one can call normal ruby methods from it similarly as in the normal HAML
files. This way we can customize them easily. A more comprehensive (and 100% better) description is
[here](http://guides.rubyonrails.org/layouts_and_rendering.html#partial-layouts).


### Angular
When Rails was created there were no single-page-apps and nodejs fancy libraries. There is a big effort to
convert as much UI code as possible into the Angular. The UI components repo mentioned above
is completely written in Angular, while the old UI contains only some parts in angular. It's
done in a way that HAML files contains also the directives and calls to the angular controller.
Angular controllers are stored in `app/assets/javascripts/controllers/`.

#### RxJS
The RxJS library is used in a simple way as a message bus so one can send events --`sendDataWithRx()`
and subscribe to a [Rx subject](https://github.com/ReactiveX/rxjs/blob/master/doc/subject.md)
--`ManageIQ.angular.rxSubject.subscribe(event => {..})`.


### Topology Graph

TODO

## Controller Layer
While the model and most of the business logic is in the `manageiq/manageiq` repository, the controller+view is in `manageiq/manageiq-ui-classic` repo.

### Router
In Rails apps, all the possible actions must be whitelisted in the router configuration. In the case of MiQ, the router is
[here](https://github.com/ManageIQ/manageiq-ui-classic/blob/036735fcd678430376402f7d81f7d0d7e5c69e5b/config/routes.rb).
Most common actions are:

* `show` (detail page of entity),
* `show_list` (list of n entities),
* `new` & `edit` (if creating and editing is supported)
* `tagging_edit` & `tag_edit_form_field_changed` (tagging mechanism in MiQ)
* `button` (when clicking on a button in the toolbar, this action is invoked)
* `quick_search` (if we want the search form field in the GTL (grid, tiles, list) view)
* `perf_top_chart` (metrics)
* ...

NOTE: These actions are implemented by actual methods on the corresponding controller class. So for instance if http get is sent
to `http://localhost:3000/container/show/26` the method `show` in the `container_controller.rb` is invoked
and the `container` entity with id `26` will be accessible in the `@record` variable. After further processing like
(setting the `@display`) the data will be rendered using those corresponding HAML template files. For the described example,
this [file](https://github.com/ManageIQ/manageiq-ui-classic/blob/256e9aa5f13de59db943fb581ec4bc56f3dcd591/app/views/container/show.html.haml) will be used.
Again, the naming is absolutely crucial here, because everything should auto-magically work when preserving those conventions.

## Gluing Everything Together
Unfortunately, there is no easy way here. Due to some legacy code, often, it is necessary to add the entity
name to some long list of other entity names to achieve a simple task. The best way to struggle with it
is using the debugger and trying to figure out why it's not working as it should (somewhere in the chain there must be a check,
if the current entity name is in some list). Another approach is to look to some existent PRs that were adding similar features and check what files
need to be modified.

### Places that needs attention
Here is a list of some of the pain points that need attention when changing the provider-related code:

* in the backend repo:
  * `db/fixtures/miq_product_features.yml` (list of features that a role can do on entity, used by RBAC)
  * `app/models/ems_refresh/` (refresh logic of the provider, basically consumes the output of `refresh_parser.sh`)
  * `product/views/YourNewEntity.yaml` (although this is only report config, it's necessary for UI to work properly, check for the similar in the directory)
* in the frontend repo:
  * `config/routes.rb` (this was described in the Router section)
  * `app/decorators/your_new_entity_decorator.rb` (there is a convention to put a placeholder icons here)
  * `app/controllers/your_new_entity_controller.rb` (the controller for the entity)
  * `app/views/your_new_entity/{show|_main|show_list|some_other_action|_some_other_partial}.html.haml`
  * `app/views/layouts/listnav/_your_new_entity.html.haml` (the side panel, this needs to be also registered in `ApplicationHelper.render_listnav_filename`)
  * `app/helpers/your_new_entity_helper/textual_summary.rb`
  * `app/helpers/your_new_entity_helper.rb`
  * `app/views/configuration/_ui_2.html.haml`
  * `app/views/layouts/listnav/` (if you need direct link in web UI from provider)
  * `app/views/shared/views/ems_common/_show.html.haml` (same as ^)
  * `app/helpers/application_helper.rb` (multiple use-cases)
  * `/app/helpers/application_helper/toolbar_chooser.rb` (toolbar with buttons)
  * `/app/helpers/application_helper/toolbar/your_new_entity_center.rb` (description of what buttons are allowed for 1 entity)
  * `/app/helpers/application_helper/toolbar/your_new_entities_center.rb` (same as above, except it's for the GTL view)
  * `app/views/layouts/_perf_options.html.haml` (metrics)

## Debugging
### Logs
There are actually two log files where you can find what is wrong.

* `log/evm.log`
* `log/development.log`

There should be a lot of SQL queries that may be handy during the development. Of course, you can use them in the good old `psql` client.

```bash
psql -U postgres vmdb_development
```
The command should open the Postgres client on the dev db. By default the development environment is active, this can be changed
by `rails s -e production`.

Even better option is to inspect the db with:

```bash
bundle exec rails dbconsole
```

This command takes into consideration the actual environment and the configured database.

### Pry
Pry is a command line oriented debugger similar to famous `gdb`.
We suggest adding this line to `Gemfile.dev.rb` (create this file if it doesn't exist in the root of manageiq/manageiq repo):

```ruby
gem 'pry-byebug'
```
Then after running `bundle install`, you should be all set. Now, adding the breakpoint means writing `binding.pry` somewhere in the code.
Once the ruby executes the code with this line, it stops the execution and opens a REPL where Ruby code can be inspected and executed.

TIP: This works also for the HAML files. But instead of using just `binding.pry`, use `- binding.pry` (and respect the indentation of the file).

### Console
Another way of debugging is just printing the variables to the console by `puts foo`. Object can have the `.to_s` method that
is responsible for printing the object (equivalent to `.toString()` method in Java), if the `.to_s` method is not implemented,
you can use the `.inspect` method that provides the info about the object.

## Rails Console
In Rails apps, you can use rails console by typing the `rails console` or `rails c` to the command line
(being in the root of the repo). This opens the REPL Ruby console, where you can type in Ruby code and it evaluates it.
What's interesting here is that you can actually alter the running Rails application by:

* creating new entities: `MyAwesomeEntity.create(params)`
* finding entities: `MyAwesomeEntity.all` / `MyAwesomeEntity.find(foo: 'bar')`
* delete: `MyAwesomeEntity.find(foo: 'bar').destroy` / `MyAwesomeEntity.delete(foo: 'bar')`
* ...

The methods like `.create`, `.all`, `.find` are actually not defined on the models, but comes from the ActiveRecord (~ORM) framework.

## Code Style
For up-to-date coding standards, consult this [guide](https://github.com/ManageIQ/guides/blob/master/coding_style_and_standards.md).
The travis build is set to check what rules are violated and report those in the PR comment. If you want to run it locally, just
type in: `rubocop` and/or `haml-lint` (if necessary, install those ruby gems).

There is also a bash helper script called [`murphy.sh`](https://github.com/zeari/miq-helpers/blob/master/murphy.sh)
 that runs the `rubocop` and `haml-lint` only on those commits that haven't been pushed yet.
It is similar to the `rubocop-git` gem.

# Common Tasks
Rather than trying to describe each part separately as before, here we would like to focus on some common tasks and provide a link to
PRs/commits that did so in the past.

## Creating new Models and Migrations
As mentioned above, there is a scaffolding helper for creating the migrations. The database knows its current version, so
if there is a new migration that hasn't been applied, it will get applied when running `rake db:migrate`. In case there was
anything wrong with the migration, one can go back and undo it by `rake db:rollback`, change the migration file and try again.

[documentation](http://edgeguides.rubyonrails.org/active_record_migrations.html)

## Handling the Refresh Logic and Saving to the DB

Refresh logic mostly happens in a `refresh_parser.rb` class. Parsed entities are then processed by core `ems_refresh.rb`.
The logic in this class has
quite strong assumptions on the data being stored. It assumes that it has the tree structure and each entity contains its kids as a nested hash.
If you are able to achieve that structure in the `refresh_parser.rb`, you are halfway done. Otherwise, good luck :]

### Defining Inventory

Providers which use graph refresh consists of Collector, Persister and Parser classes.
When the Collector loads data from an external provider, the Persister defines the inventory structure based on InventoryCollection objects. 
Inventory is then saved to the VMDB (app database). Each inventory collection is mapped to an ActiveRecord model.
Parser maps data collected from the provider to the common format defined by the ActiveRecord model.

THe persister InventoryCollection definition is described [here](persister/inventory_collections.md).

## Registering the Features for RBAC
If everything is as it should be but you still can't see anything in the UI, permissions may be the reason. MiQ has the RBAC model
that checks if the user in the current role is able to access the feature. This is described in the yaml file called `miq_product_features.yml`.

When adding the new entity, it is also necessary add the record
[here](https://github.com/ManageIQ/manageiq/blob/master/db/fixtures/miq_product_features.yml) and describe it.
It is best to copy&paste the existing definition and change the details.

## If the Side Panel or Toolbar is Missing
If the screen should have the left panel with navigation, it needs the be whitelisted in:
`ApplicationHelper.render_listnav_filename`. There are more places in that "god file" where new entity needs to be
registered (for instance if it wants to participate in the GTL views).

The side navigation layout is described in `/app/views/layouts/listnav/_X.html.haml`

As for the missing toolbar, adding the plural of the entity name for list and singular for the detail page to this file
`/app/helpers/application_helper/toolbar/Xs_center.rb` is needed + register itself here:
`/app/helpers/application_helper/toolbar_chooser.rb:439` (2 places in that file, 1 for singular and 1 for plural).
Then it automagically should work.

## Exposing the Live Metrics for Entity

If the metric graphs should be displayed for your entity, you need to do the following:

* `app/controllers/application_controller/performance.rb`,
* including the `LiveMetricMixin` in the entity model,
* creating the entity that ends with `Perf`, etc.
* changing `app/views/layouts/_perf_options.html.haml`
* the `show.haml` of the entity has to contain:

```haml
- if @showtype == "performance"
    = render(:partial => "layouts/performance")
    :javascript
      var miq_after_onload = "miqAsyncAjax('#{url_for(:action => @ajax_action, :id => @record)}');"
```

* adding `perf_chart_chooser` action into `router.rb` to corresponding entity
* adding to `db/fixtures/miq_product_features.yml` (`X` is the entity name)

```yaml
- :name: Utilization
    :description: Show Capacity & Utilization data of X
    :feature_type: view
    :identifier: X_perf
```

* create `/product/live_metric_X.yaml` similar to the existing ones
* creating a yaml file in `product/charts/layouts/{Y}_perf_charts/X.yaml` similar to the existing ones (`X` is entity name and Y is the interval or "realtime" phrase). The cols ids must match with the ids defined in `/product/live_metric_X.yaml`
* add the tests

