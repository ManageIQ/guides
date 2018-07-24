## Excending the UI with buttons, dialogs and executing Ansible Playbooks

### Context
We want to allow the provider authors to extend ManageIQ with Ansible playbooks
and roles. ManageIQ core provides the capability to execute an Asible playbook
from the provider repository. The ManageIQ UI provides a way to call that
playbook from a toolbar. Before calling the playbook additional parameters can
be collected using a custom dialog.

### Provider workflow

 * Implement your Ansible playbooks and place them in the provider repo `manageiq-provider-xxx`.
 * Implement your custom dialogs as React components or ManageIQ dynamic (service) dialog, place them in the provider repo.
 * Create a toolbar extension class and place it in the provider repo under `app/helpers`.

### Extending the toolbars

Providers can add new button groups to existing [toolbars](toolbars.md). Specificaly the "Center toolbars" can be extended this way. Currently toolbar extensions can add new `button_group`s to the toolbar.

On top of what is documented in the [toolbars](toolbars.md) page providers can specify what Dialog has to be displayed then a toolbar button is pressed.

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
                                             :button         => :magic,
                                             :modal_title    => N_('Create a Security Group'),
                                             :component_name => 'CreateAmazonSecurityGroupForm',
                                              }.to_json},
              :klass => ApplicationHelper::Button::ButtonWithoutRbacCheck),
        end
      end
    end
  end
end
```

Above is an exampe where provider `ManageIQ::Providers::Amazon` is extending existing toolbar `EmsCloudCenter`with a new group containing a single button.

When the button is pressed, a modal will be opened with a form implemented as a React class named `CreateAmazonSecurityGroupForm`. The title of the modal will be `Create a Security Group`.

### Creating Forms

#### React based forms

The example above references a React class `CreateAmazonSecurityGroupForm`. In this scenario the React class is also responsible for submitting a request with the collected data to the [API](calling_api.md).

The React code can be part of the provider repository or it can be added as the dependency. Provider repositories can add dependencies in their `package.json`.

It's advised to split the React class into 2 parts:
 * UI only part implementing the form elements and
 * part adding the handling of Ok and Cancel buttons and implementing the [API call](calling_api.md).

This is shown in the examples here:

* [Form Example](https://github.com/ManageIQ/react-ui-components/tree/master/src/amazon-security-form-group)
* [Using Redux](https://github.com/ManageIQ/manageiq-ui-classic/pull/3509)

#### Dialog player forms

Simple forms can be implemented using the Dialog Player. Dialog Player comes with a WYSIWYG Dialog Editor. This approach is used in Service Dialogs in ManageIQ.

* [Form Definition Example](https://github.com/ManageIQ/manageiq-providers-amazon/pull/468/files#diff-5de6773b08e78af7f4d0b3aff5355fa6)
