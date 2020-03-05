## Extending the UI with buttons, dialogs and executing Ansible Playbooks

### Context

We want to allow the provider authors to extend ManageIQ with Ansible playbooks
and roles. ManageIQ core provides the capability to execute an Ansible playbook
from the provider repository. The ManageIQ UI provides a way to call that
playbook from a toolbar. Before calling the playbook, additional parameters can
be collected using a custom form.

### User interaction example

 * User opens a list of Instances.
 * From the list, the user selects one Instance and displays its detail page.
 * On the detail page in the top toolbar extra button (button groups) are displayed with special actions relevant only for Instances coming from a specific provider.
 * User presses a button.
 * (optional step) a dialog comes up for the user to fill in whatever arguments are needed for the special action.
 * User clicks "Ok".
 * Special operation is executed using the ManageIQ API. A simple message is displayed on the screen (flash message) informing that the operation was fired.

### Provider workflow

 * Implement Ansible playbooks and place them in the provider repo `manageiq-provider-xxx`.
 * Implement custom forms as React components or a ManageIQ Dynamic (service) Dialog. Place them in the provider repo.
 * Create a toolbar extension class and place it in the provider repo under `app/helpers`.

### Extending the toolbars

Providers can add new button groups to existing [toolbars](toolbars.md). Specifically, the "Center toolbars" can be extended this way. Currently, toolbar extensions can add new `button_group`s to the toolbar.

In addition to what is documented on the [toolbars](toolbars.md) page, providers can specify what Dialog has to be displayed then a toolbar button is pressed.

```ruby
module ManageIQ
  module Providers
    module Amazon
      module ToolbarOverrides
        class EmsCloudCenter < ::ApplicationHelper::Toolbar::Override
          button_group('magic', [
            button(
              :magic,
              'fa fa-magic fa-lg',
              t = N_('Magic'),
              t,
              :data  => {'function'      => 'sendDataWithRx',
                         'function-data' => {:controller     => 'provider_dialogs', # this one is required
                                             :modal_title    => N_('Create a Security Group'),   # title of modal displaying the form
                                             :component_name => 'CreateAmazonSecurityGroupForm', # name of React component implementing the form
                                              }.to_json},
              :klass => ApplicationHelper::Button::ButtonWithoutRbacCheck),
        end
      end
    end
  end
end
```

Above is an example where provider `ManageIQ::Providers::Amazon` is extending existing toolbar `EmsCloudCenter`with a new group containing a single button.

When the button is pressed, a modal will be opened with a form implemented as a React class named `CreateAmazonSecurityGroupForm`. The title of the modal will be `Create a Security Group`.

### Creating Forms

#### React based forms

The example above references a React class `CreateAmazonSecurityGroupForm`. In this scenario, the React class is also responsible for submitting a request with the collected data to the [API](calling_api.md).

The React code can be part of the provider repository or it can be added as the dependency. Provider repositories can add dependencies in their `package.json`.

It's recommended that the React class be split into two parts:
 * UI only part implementing the form elements and
 * part adding the handling of "Ok" and "Cancel" buttons and implementing the [API call](calling_api.md).

This is shown in the examples here:

* [Form Example](https://github.com/ManageIQ/manageiq-providers-lenovo/pull/251)
* [Using Redux](https://github.com/ManageIQ/manageiq-ui-classic/pull/3509)

#### Dialog player forms

Simple forms can be implemented using the Dialog Player. Dialog Player comes with a WYSIWYG Dialog Editor. This approach is used in Service Dialogs in ManageIQ.

* [Form Definition Example](https://github.com/ManageIQ/manageiq-providers-amazon/pull/468/files#diff-5de6773b08e78af7f4d0b3aff5355fa6)

Example definition of a button that opens a Dialog Player dialog follows.

```ruby
module ManageIQ
  module Providers
    module Amazon
      module ToolbarOverrides
        class EmsCloudCenter < ::ApplicationHelper::Toolbar::Override
          button_group('magic', [
            button(
              :magic_player,
              'fa fa-magic fa-lg',
              t = N_('Magic player'),
              t,
              :data  => {'function'      => 'sendDataWithRx',
                         'function-data' => {:controller  => 'provider_dialogs', 	      # this one is required
                                             :dialog_name => 'test',		 	      # name of dialog
                                             :dialog_title => N_('Magic Provider Dialog'),    # title of modal displaying the form (dialog)
                                             :class       => 'ManageIQ::Providers::Amazon',   # namespace of this provider
                                             :entity_name => 'ems_cloud',		      # entity name for an API call
                                             :action_name => 'more_foobar',		      # action name for an API call
                                             :success_message => N_('Magic just happened !'), # text of flash message
                        }.to_json},
              :klass => ApplicationHelper::Button::ButtonWithoutRbacCheck),
          ])
        end
      end
    end
  end
end

```

When a user clicks this button, a series of actions take place.
1. Dialog definition is fetched from disk. The dialog definition has to be stored under the name matching the `:dialog_name` argument from path `<provider_repo_root>/dialogs/<dialog_name>.json`.
2. A modal is displayed with a form created from the dialog definition. The correct dialog data is located using `:class` and `dialog_name`. Title of the modal is taken from `:dialog_title`.
3. User interacts with the form.
4. If "Ok" was pressed by the user, an API call is made by POST to `/api/<entity_name>` and `{ action: <action_name> }`. Serialized data from the form are passed in `data` key.
5. If the call is successfull the `:success_message` is displayed as a flash message. Otherwise an error message is displayed.

