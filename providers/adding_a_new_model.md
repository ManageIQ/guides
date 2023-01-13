## Adding A New Model

So you've added your AwesomeCloud provider and collected everything that ManageIQ has tables for, but your cloud is so awesome it has something ManageIQ doesn't have yet.  In order to manage this new type of inventory in ManageIQ you have to create a new model for it.

Before we jump in make sure that you are familiar with the following guides:
- [dev-guide](./dev-guide.md)
- [Inventory Collections](./persister/inventory_collections.md)
- [Refresh](./refresh.md)

As well as [Rails Models](https://guides.rubyonrails.org/active_record_basics.html) specifically ActiveRecord and Migrations.

### Create a new database table
Before you can add a new model, you must create a database table to store the data.  This is done by using the migration generator.
1. If you haven't already, clone the manageiq-schema repository and add it to your bundler overrides.
2. In a terminal type `rails generate migration create_<table_names>` (model name in plural), for instance: create_physical_storages. A migration file will be created on the vm in the repo `manageiq-schema`, in directory `db/migrate`.
3. Edit the file and add necessary fields:
   1. Use existing schema files as reference.
   2. `ems_ref` is the field used for storing the id that a model record has in its provider backend db. This enables to send CRUD requests from miq back to the provider, using `ems_ref` to reference to the correct record there.
   3. `t.references` are fields that hold references to other tables (foreign keys) usually a with `bigint` index. For instance, every schema should have a reference field to it `ems`:
   ```ruby
   t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
   ```
4. When the migration is ready, change directory to your core manageiq directory and run `rails db:migrate`.
5. If you need to change something and have to re-run the migration again you can rollback a migration: `rails db:rollback`. Optional: specify the number (N) of rollbacks to perform by adding `STEP=N`.

### Create the new Model
In the main manageiq repo:
1. Create the model class in `app/models`:
   1. Add a model class file and specify the necessary relations (`belongs_to`, `has_many`, etc.). Once again, it's helpful to check existing models.
   2. The name of the model file should be in `snake_case` format and singular, not plural: `cloud_database.rb` and not `cloud_databases.rb`.
   3. The classes in this path are general, to be used throughout the ManageIQ platform. For behavior desired in only in a particular provider, a model can be inherited and overridden in that provider's `app/models` dir.
   4. For instance, the general `cloud_database` in the main repo defines CRUD methods with basic behavior, common to all its implementations. However, after performing the basic common necessities, each of its CRUD methods calls another final "raw" CRUD method, which is supposed to actually perform the operation. These raw methods are left unimplemented in the general `cloud_database`, and must be implemented by a subclass in the provider's repo.
   5. Include a `belongs_to :ext_management_system, :foreign_key => :ems_id, , :class_name => "ManageIQ::Providers::CloudManager"`
   6. At the base class all features should default to `supports_not` so e.g. add `supports_not :create` to your base model.
2. Add the collection to the manager type in `app/models/manageiq/providers/cloud_manager.rb` (replace `cloud_manager` with the relevant provider):
   1. Add the `has_many` association (e.g. `has_many :cloud_databases`) as well as any modifiers you want such as `:dependent => destroy`.  `has_many :cloud_databases, :foreign_key => :ems_id, :dependent => :destroy`
3. Add the new model to the inventory collections
After adding a schema and a model class, we would like to update its db table on every `EmsRefresh` with data we collect from the parallel model on the provider's backend side.  
In the main manageiq repo:
  1. `app/models/manageiq/providers/inventory/persister/builder/cloud_manager.rb`:  
     Add a method with the model's plural name:
     ```ruby
     def cloud_databases
       add_common_default_values
     end
     ```

### Update your provider to collect the new model

In the provider repo, (e.g. `manageiq-providers-awesome_cloud`) in `app/models/manageiq/providers/awesome_cloud/inventory/`:
1. `collector/cloud_manager.rb`: Add a method with the model's plural name, which calls the `GET` method of the model in the provider's client:
   ```ruby
   def cloud_databases
     @cloud_databases ||= compute_client.get_databases
   end
   ```
2. `collector/target_collection.rb`: Add a method with the model's plural name, which defines and returns a container for the collection. This can be an empty `[]`, but can also include more logic if needed:
   ```ruby
   def cloud_databases
     []
   end
   ```
3. `parser/cloud_manager.rb` (see Inventory::Parser in [Refresh](./refresh.md) for examples):
   1. Add the model's plural name to the `parse` method in the top.
   2. Add a method with the model's plural name, which calls the collector method (added in stage 2) and passes the fields that were retrieved from the client to a `build` method of the persister (which later saves them to the miq db).
   3. The parser is also the place for light processing of the data received from the client, in case it needs formatting or manipulation before it is saved to the db.
4. `persister/cloud_databases.rb` Add a new call to `add_collection(cloud, :cloud_databases)`, which saves the data to the miq db. `cloud` here is the name defined in `app/models/manageiq/providers/inventory/persister/builder/persister_helper.rb` for the `builder_class` of this provider

### Add an API Endpoint for the New Model
Now that we have a model with data collected from the provider's backend, we might like to access and manipulate it without directly touching the db, by making an API request. This is necessary mainly for performing CRUD operations requested by the user through the UI, which must be passed on to the provider's backend.  

In the main manageiq repo in `db/fixtures/miq_product_features.yml`: Add the model by copying from existing models. Pay attention to singular vs plural when writing the name of the model: Plural in `:description`, snake_case singular in `:identifier`

In `manageiq-api` repo:
1. `app/controllers/api/`: Add a controller, use existing files as reference. If the only operation necessary is retrieving data, the controller can be as thin as:
   ```ruby
   module Api
     class CloudDatabaseController < BaseController
     end
   end
   ```
   Any other operation requires adding a method to handle its request.
2. `config/api.yml`: Add the model by copying from existing models. This `yml` specifies the possible `GET` and `POST` operations available for the model, both for the whole `collection` (all the instances, or `resources` in this terminology) and for a specific `resource`.
3. `spec/requests/:` Add a spec for testing the feature provided by the new API. Pay attention to singular vs plural when writing the name of the model, follow closely existing specs.

### Conclusion
This is it! You've added a new schema and a new model, connected it to its relevant provider, integrated it into the Inventory flow to keep it updated with data from the backend, and opened up an API endpoint to perform CRUD (and custom) operations on the model, which could send requests back to the provider backend.   

Any changes requested and performed in the backend will echo back to your ManageIQ model on the next `EmsRefresh`.
