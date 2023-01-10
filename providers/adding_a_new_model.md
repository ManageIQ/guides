# Adding A New Model

This article provides examples for adding a new model to ManageIQ, to represent and manipulate a model from a provider's backend. The article uses the autosde provider plug-in and its `storage_manager` as example. Note that the exact names, details and file paths may differ between providers.  

Related articles which may expand on subjects mentioned here:
- [dev-guide](./dev-guide.md)
- [Inventory Collections](./persister/inventory_collections.md)
- [Refresh](./refresh.md)

### Create A New Schema
Before adding a new model, create a new schema to build its table in miq db.   
1. In a miq vm terminal type `rails g migration create_<table_names>` (model name in plural), for instance: create_physical_storages. A migration file will be created on the vm in the repo `manageiq-schema`, in directory `db/migrate`.
2. Copy it from the vm to your local environment, using your editor/IDE.
3. Edit the file and add necessary fields: 
   1. Use existing schema files as reference.
   2. `ems_ref` is the field used for storing the id that a model record has in its provider backend db. This enables to send CRUD requests from miq back to the provider, using `ems_ref` to reference to the correct record there.
   3. `t.references` are fields that hold references to other tables (foreign keys) usually a with `bigint` index. For instance, every schema should have a reference field to it `ems`:
   ```ruby
   t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
   ```
4. When the schema is ready, redeploy it to the vm and type `rails db:migrate` in the vm terminal.
5. Rollback a migration: `rails db:rollback`. Optional: specify the number (N) of rollbacks to perform by adding `STEP=N`.
6. `manageiq-schema/spec/migrations`: A new spec file should also be auto-created here. Copy it from the vm to your local environment and push it to Git together with the schema.

### Form a New Model Class and Register it in the Provider's Model Class
In the main manageiq repo:
1. `app/models`: 
   1. Add a model class file and specify the necessary relations (`belongs_to`, `has_many`, etc.). Once again, it's helpful to check existing models.
   2. The name of the model should be in `snake_case` format and singular, not plural: `physical_storage` and not `physical_storages`.
   3. The classes in this path are general, to be used throughout the ManageIQ platform. For behavior desired in only in a particular provider, a model can be inherited and overridden in that provider's `app/models` dir. 
   4. For instance, the general `physical_storage` in the main repo defines CRUD methods with basic behavior, common to all its implementations. However, after performing the basic common necessities, each of its CRUD methods calls another final "raw" CRUD method, which is supposed to actually perform the operation. These raw methods are left unimplemented in the general `physical_storage`, and must be implemented by a subclass in the provider's repo.
2. `app/models/manageiq/providers/storage_manager.rb` (replace `storage_manager` with the relevant provider): 
   1. Add the name of the new model in plural form (`physical_storages`) with the relevant relation: usually a `has_many` with `:dependent => destroy`.
   2. `supports` specifies that a feature (for instance, your new model) is generally supported by - and available for - all uses and implementations of this provider class. 
   3. `supports_not` makes the feature only supported by those providers who inherit the general model in their provider plug-in repo, and specify `supports` for that feature in their implementation. For instance: the general `storage_manager` specifies `has_many cloud_volumes` but also `supports_not cloud_volumes`, and the autosde provider inherits it and in its own `storage_manager` class specifies `supports cloud_volumes`.  

### Connect the New Model to the Provider Backend - The Inventory Flow:
After adding a schema and a model class, we would like to update its db table on every `EmsRefresh` with data we collect from the parallel model on the provider's backend side.  
In the main manageiq repo:
1. `app/models/manageiq/providers/inventory/persister/builder/storage_manager.rb`:  
   Add a method with the model's plural name:
   ```ruby
   def cloud_volumes
     add_common_default_values
   end
   ```
In the provider repo, (e.g. `mangeiq-providers-autosde`) in `app/models/manageiq/providers/autosde/inventory/`:
2. `collector/storage_manager.rb`: Add a method with the model's plural name, which calls the `GET` method of the model in the provider's client:
   ```ruby
   def cloud_volumes
     @cloud_volumes ||= @manager.autosde_client.VolumeApi.volumes_get
   end
   ```
3. `collector/target_collection.rb`: Add a method with the model's plural name, which defines and returns a container for the collection. This can be an empty `[]`, but can also include more logic if needed:
   ```ruby
   def cluster_volume_mappings
     []
   end
   ```
4. `parser/storage_manager.rb` (see Inventory::Parser in [Refresh](./refresh.md) for examples):
   1. Add the model's plural name to the `parse` method in the top.
   2. Add a method with the model's plural name, which calls the collector method (added in stage 2) and passes the fields that were retrieved from the client to a `build` method of the persister (which later saves them to the miq db).
   3. The parser is also the place for light processing of the data received from the client, in case it needs formatting or manipulation before it is saved to the db.
5. `persister/storage_manager.rb` Add a new call to `add_collection(storage, <plural_name>)`, which saves the data to the miq db. `storage` here is the name defined in `app/models/manageiq/providers/inventory/persister/builder/persister_helper.rb` for the `builder_class` of this provider:
   ```ruby
   def initialize_inventory_collections
     add_collection(storage, :ext_management_system)
     add_collection(storage, :physical_storages)
     add_collection(storage, :cloud_volumes)
   end
   ```

**Note:** It is possible to collect data from the provider backend and save it to the provider's model itself in miq.  
This requires adding `ext_management_system` in stages 4-5. In stage 4, be sure to reference the provider's `guid` so it will be found and updated in the db.

In the following example, a provider's `jsonb` field named `capabilities` is populated with a model called `capability_values`, which was collected from the provider in stages 2-3:
```ruby
  def ext_management_system
    persister.ext_management_system.build(
      :guid         => persister.manager.guid,
      :capabilities => collector.capability_values
    )
  end
```

### Open Up an API Endpoint for the New Model
Now that we have a model with data collected from the provider's backend, we might like to access and manipulate it without directly touching the db, by making an API request. This is necessary mainly for performing CRUD operations requested by the user through the UI, which must be passed on to the provider's backend.  

In the main manageiq repo in `db/fixtures/miq_product_features.yml`: Add the model by copying from existing models. Pay attention to singular vs plural when writing the name of the model: Plural in `:description`, snake_case singular in `:identifier` 

In `manageiq-api` repo:
1. `app/controllers/api/`: Add a controller, use existing files as reference. If the only operation necessary is retrieving data, the controller can be as thin as:
   ```ruby
   module Api
     class PhysicalStorageFamiliesController < BaseController
     end
   end
   ```
   Any other operation requires adding a method to handle its request.
2. `config/api.yml`: Add the model by copying from existing models. This `yml` specifies the possible `GET` and `POST` operations available for the model, both for the whole `collection` (all the instances, or `resources` in this terminology) and for a specific `resource`.
3. `spec/requests/:` Add a spec for testing the feature provided by the new API. Pay attention to singular vs plural when writing the name of the model, follow closely existing specs.

### Conclusion
This is it! You've added a new schema and a new model, connected it to its relevant provider, integrated it into the Inventory flow to keep it updated with data from the backend, and opened up an API endpoint to perform CRUD (and custom) operations on the model, which could send requests back to the provider backend.   

Any changes requested and performed in the backend will echo back to your ManageIQ model on the next `EmsRefresh`.