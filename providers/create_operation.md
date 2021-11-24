# Guide for adding a "new" button 
You need to already have an application record and a GUI controller that implements a GUI list view (including templates).
This guide will tell you how to add a button to the list view that creates new instances of the item your application record represents.\
In this guide we will implement the actual creation of the record in an EMS provider.\
If creation of your items doesn't require interaction with an EMS API, you can adjust the process described here to implement it in manageiq core instead.

The guide assumes that 
* Your application-record is in `app/models/your_item.rb`
* Your application-record belongs to an EMS. Usually its instances appear in MIQ by being refreshed from the EMS.
* Your UI controller is in `plugins/manageiq-ui-classic/app/controllers/your_item_controller.rb`
* Your provider is in `plugins/manageiq-providers-your_provider`
* A menu for your item's list view is in `plugins/manageiq-ui-classic/app/heplers/application_helpers/toolbar/your_items_center.rb`
* You have an application record in `plugins/manageiq-providers-your_provider/app/models/manageiq/providers/your-provider/your_item.rb`. 

You will work with the following repositories. 
* manageiq
* manageiq-ui-classic 
* manageiq-api
* manageiq-providers-your_provider (if you implement the creation in an EMS)

## Application Record
### Base Application Record
Make sure that the base application-record in `app/models/your_item.rb` has 
* `self.create_your_item`
* `self.raw_create_your_item`
* `self.create_your_item_queue`

If these aren't present, add these methods to the base class by copying them from some other model in `app/models/`.\
Adjust as needed to fit your item.

### Provider Application Record
Make sure that your application-record in `plugins/manageiq-providers-your_provider/app/models/manageiq/providers/your-provider/your_item.rb` extend `app/models/your_item.rb` with Rails STI. 

In the application-record in your provider, you need to add two entries.
1. `supports :create`
2. `def self.raw_create_your_item(ext_management_system, options = {})` 

The method `self.raw_create_your_item` performs the actual work of creating.\  
The options hash will contain what you get from your JS form.\
In this method you need to call your EMS's API to create a real-world instance of your item.\
You need to check if the request went through OK. If not, you need to throw an exception.
If the request went OK, you will want to schedule a refresh so that the change will be reflected in MIQ DB.

## Adding support for the new operation 
In `app/models/ext_management_system.rb` add `supports_attribute :supports_create_your_item, :child_model => "YourItem"`.

## Toolbar Button
#### Add button to the menu
Find the menu file in `plugins/manageiq-ui-classic/app/heplers/application_helpers/toolbar/your_items_center.rb`.\
Add a button into the menu for creating your items. The button needs to be called `:your_item_new`. You can copy a `..._new` button from another menu and adjust to fit your item.

**Note** Usually we only add "new" button into the list view page and not into a detailed view.\
If you want to also add a "new" button inside you textual summary page you need to do modification to `plugins/manageiq-ui-classic/app/heplers/application_helpers/toolbar/your_item_center.rb`. But this is not part of this guide.

#### Add button class
Create a button class to handle "new" operation. 
It needs to be in `manageiq-ui-classic/app/helpers/application_helper/button/your_item_new.rb`. You can copy another button and adjust it.

## JS Form
You need to create a form-folder in `manageiq-ui-classic/app/javascript/components/your-item-form/`. With `index.jsx` and `your-item-form.schema.js`.
You can copy from another form and adjust as needed.

Here you determine the GUI form the user will see when creating a new instance of your item. I won't go into the details of it in this guide.\
When developing, it's safest to start with a minial form just to see that it's working.

Note that the fields on your form will constitute the `options` argument for your `self.raw_create_your_item` method.

After you add your form, you need to register it in `component-definitions-common.js`.

## The UI Controller
In your controller in `plugins/manageiq-ui-classic/app/controllers/your_item_controller.rb` you need to add the `new` method.\
You can copy it from another controller and adjust as needed.

Another thing you need in your controller is a method called `specific_buttons(pressed)`. If you don't have it already, copy it from another controller.\
The method consists of a `case`.\
Add the following `when` to the case. If you have just copied the method from another controller you can remove all other `when`s.
```ruby
when 'your_item_new'
  javascript_redirect(:action => 'new')
end
```

## haml template for 'new' operation
Create `new.html.haml` under `plugins/manageiq-ui-classic/app/views/your_item/`. You can copy it from another item and adjust as needed.
Make sure to point at your JS Form which you defined above `react 'YourItemForm'`

## UI routes
In `manageiq-ui-classic/config/routes.rb`, you need to find the section for your_item. Then you need to make sure there's `new` in the get section, and `button` in the post section.

## Product Feature
Find your item's product feature list in `manageiq/db/fixtures/miq_product_features.yml`. 
Make sure that it has a section for 'add', as below
```yaml
- :name: Your Item   
  ...
  - :name: Modify
    :children:    
    - :name: Add
      :description: Add A Your Item
      :feature_type: admin
      :identifier: your_item_new
```

## API Controller
If there isn't one, create a controller for your item in `manageiq-api/app/controllers/api/your_items_controller.rb`. You can copy one of the existing controllers and adjust to your item.

Make sure that there is a `create_resource` method in the api controller. If not, copy if from some other controller and adjust to fit your item.\
This method is supposed to call the method`create_your_item_queue` on the base application-record.\
An API controller with a good example of `create_resource` method is `auth_key_pairs_controller.rb`, so you can copy-paste from there and adjust as needed.

## API Routes
You need to have appropriate routes in `manageiq-api/api.yml`.\

If you are adding a new controller, you'll need to add a new entry for `:your_items:` in `manageiq-api/api.yml/collections`. You can copy from one of the existing routes and adjust.\

Make sure the hash for your routes contains the following:
* The `verbs` section needs to contains both `Get` and `Post`. For example, you could write `:verbs: *gp`\ 
* Under the `collection_actions` section, make sure you have
```yaml
    :collection_actions:
      :post:
      - :name: create
        :identifier: your_item_new
```

### API Controller Specs
The spec file needs to be in `plugins/manageiq-api/spec/requests/your_items_spec.rb`.\
If a spec file doesn't exist for the api-controller, such as when you have just created a new api-controller, create a new one.  

Add the following tests to the spec file. You can copy-paste them from other specs and adjust to your item.

1. Good path where a POST succeeds in creating a new item.
Make sure to use `api_basic_authorize(collection_action_identifier(:host_initiator_groups, :create))` in the test.
2. A create request without a valid ems-id should fail.
3. A create request for a user without an appropriate role should fail.
We test this by repeating item #1, but calling `api_basic_authorize` without any arguments
4. A create request for models that doesn't have `supports :create` should fail. You can use `stub_supports` for this. 

## Specific EMS support
If you need to have support for buttons in the menu for a specific ems, for example in case you are entering the list view page from a specific ems dashboard make sure the following are set correctly:
1. In app/helpers/application_helper/toolbar_chooser.rb make sure your_item is set in two places inside `center_toolbar_filename_classic` function
2. `plugins/manageiq-ui-classic/app/views/your_item/new.html.haml` should pass `storageManagerId` to JS Form. Make sure `new.html.haml`, `index.jsx` and `your-item-form.schema.js` are set correctly to handle the `storageManagerId`.
