# Dialog Editor

## Angular components

### Dialog Editor

[`%dialog-editor`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/dialog-editor) is the component on the top of the hierarchy of the whole editor.

The overall dialog editor hierarchy is as follows:
```haml
%dialog-editor
  %dialog-editor-tabs
  %dialog-editor-boxes
    | %dialog-editor-field
  %dialog-editor-modal -# modal for editing properties of field/tab/box
    | %dialog-editor-modal-tab
    | %dialog-editor-modal-box
    | %dialog-editor-modal-field
        | %dialog-editor-modal-field-template -# per field type
```

The structure of JSON object used to describe the service dialogs is as follows:

```javascript
'content': [{
  'dialog_tabs': [{
    ...
    'dialog_groups': [{
      ...
      'dialog_fields': [...],
    }],
  }],
}],
```


### Dialog Tabs

[`%dialog-editor-tabs`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/tab-list) displays a list of tabs assigned to the dialog.

It is the main component as all the content is stored inside the object.

At the beginning, the component's controller loads the tabs of the dialog:
```javascript
this.tabList = this.DialogEditor.getDialogTabs();
```
and assigns id of the currently active tab in the  `activeTab` variable in the `DialogEditor` service.

#### `addTab()`

function `addTab` creates a new empty tab, pushes it to the array with the other tabs, and updates `activeTab` to the new tab.
```javascript
{
  description: __('New tab ') + nextIndex,
  display: 'edit',
  label: __('New tab ') + nextIndex,
  position: nextIndex,
  active: true,
  dialog_groups: [],
}
```

#### `removeTab(id: number)`

removes the tab with the ID sent in parameter and updates the `activeTab`.

#### Update positions of tabs

Because it is possible to remove (or just move the position) tab in the middle of the list, after every change the positions are updated by calling `updatePosition` method defined in the `Dialog Editor` service:
```javascript
this.DialogEditor.updatePositions(this.tabList);
```

### Dialog Groups

On the first level, the [`%dialog-editor-boxes`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/box) component iterates through all the tabs, selects the one that is `active`, and renders its groups:

```html
ng-repeat='tab in vm.dialogTabs'
ng-if='tab.position === vm.service.activeTab'
```

After, it iterates through all the tabs, and calls `%dialog-editor-field` component belonging to the group (decided by the position of the group).

Working with groups is very similar to working with tabs -- `addBox()`, `removeBox(id: number)` have the same purpose.

After every change, the position needs to be updated:

```javascript
this.DialogEditor.updatePositions(
  this.dialogTabs[this.DialogEditor.activeTab].dialog_groups
);
```

The Group is `droppable` which means that elements can be Drag&Drop-ed into the content of the group.

Therefore in the controller of the component handling for updating position of dialog fields needs to be done:

```javascript
public droppableOptions(e: any, ui: any) {
  const elementScope: any = ng.element(e.target).scope();
  let droppedItem: any = elementScope.dndDragItem;
  let droppedPlace: any = elementScope.box;
  // update name for the dropped field
  if (!_.isEmpty(droppedItem)) {
    this.updateFieldName(droppedItem);
  }
  // update indexes of other boxes after changing their order
  this.DialogEditor.updatePositions(
    droppedPlace.dialog_fields
  );
}
```


### Dialog Fields

The most important part of [`%dialog-editor-field`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/field) component is `ng-switch` in the template of the component, that renders the dialog field according to its type (`on="vm.fieldData.type"`).

All the possible fields and their parameters are listed in this component.

The dialog field types are:

- Text Box
- Text Area
- Check Box
- Date Control
- Date Time Control
- Dropdown List
- Radio Button
- Tag Control

In case of Dropdown, the `default_value` can be represented either as an array (if the Dropdown is multiselect) or a string. For multiselect dropdowns there is a method for converting the `default_value` attribute:

```javascript
public convertValuesToArray() {
  this.fieldData.default_value = angular.fromJson(this.fieldData.default_value);
}
```

### Modal

[`%dialog-editor-modal`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/modal) does not contain any template for the component. Instead it contains behavior for modal used to edit details for Tabs, Groups and Fields.

The primary function of the component is to load data it needs. Each type has its own mehthods to load the data into `this.modalData`. The source for the data is again the commonly used `DialogEditor` service method: `this.DialogEditor.getDialogTabs()`.

```typescript
public loadModalTabData(tab: number)
public loadModalBoxData(tab: number, box: number)
public loadModalFieldData(tab: number, box: number, field: number)
```

Modal controller also contains methods `addEntry()` and `removeEntry()` that are specific for Dropdown List or Radio Button component.

`resolveCategories()` , `setupCategoryOptions()` and `currentCategoryEntries()` are methods specific for Tag Control fields.

The methods are shared with other controllers by binding them to the component's template in `buildTemplate()`.

Displaying the modal is done by `showModal(options: any)`.

#### Tab Modal

In [`dialog-editor-modal-tab`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/modal-tab) component, only the label and description of the Dialog Tab is set.

#### Group Modal

[`dialog-editor-modal-box`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/modal-box) is also only used to set label and description of the Dialog Group.

#### Field Modal

The main purpose of [`dialog-editor-modal-field`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/modal-field) is similar to the [`%dialog-editor-field`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/field) component.

The component's template mostly consists of `ng-switch`, which renders templates of specific fields from the `modal-field-template` component described lower, with necessary methods passed into the component through the binding described in [`%dialog-editor-modal`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/modal) component.

Example for the Radio Button Dialog Field:
```html
<dialog-editor-modal-field-template
ng-switch-when="DialogFieldRadioButton"
template="radio-button.html"
show-fully-qualified-name="vm.showFullyQualifiedName"
tree-options="vm.treeOptions"
modal-tab-is-set="vm.modalTabIsSet"
modal-tab="vm.modalTab"
add-entry="vm.addEntry"
remove-entry="vm.removeEntry"
modal-data="vm.modalData">
```
Label and Description for the Dialog Field are also set in this component, as well as setting Dialog Field to be *Dynamic* or *Reconfigurable*, as these properties are same for all the fields except Tag Control types.

#### Field Template

Controller of [`dialog-editor-modal-field-template`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/modal-field-template) contains mostly bindings to the methods related to specific components.

The main part of the component are templates for each of the dialog fields. All the parameters for Dialog Fields are described in the templates of this component.

The modal for Dialog Fields contains three permanent tabs - *Field Information*, *Options*, *Advanced*. If the Dialog Field is set as `dynamic`, a new tab with an *Overridable Options* heading is displayed.

In *Field Information* all the fields must have a `name` that is unique in the dialog, optionally a `label`, `description`, and (as mentioned before, except Tag Control) all the fields can be set as `dynamic` *(boolean)*.

In the *Advanced* tab, the `reconfigurable` *(boolean)* option can be set.

All the other parameters for the components the can be set in *Options* or *Overridable Options* tab through the modal are as follows:

##### Text Box

  - **if `dynamic` is not checked:**
    - `data_type` *(select - string / integer)*
    - `default_value` *(string)*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `options.protected` *(boolean)* -- for passwords, value will be replaced with `*`
    - `required` *(boolean)*
    - `read_only` *(boolean)*
    - `validator_type` *('regex' (string) / false (boolean))*
    - `validator_rule` *(string; only if `validatior_type` has a value `'regex'`)*
    - `visible` *(boolean)*
  - **if the field is `dynamic`:**
    - `data_type` *(select - string / integer)*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `load_values_on_init` *(boolean)*
    - `options.protected` *(boolean)* -- for passwords, value will be replaced with `*`
    - `required` *(boolean)*
    - `resource_action` *(path to automate method)*
    - `show_refresh_button` *(boolean)*
    - `validator_type` *('regex' (string) / false (boolean))*
    - `validator_rule` *(string; only if `validatior_type` has a value `'regex'`)*
    - **In *Overridable Options* tab:**
      - `default_value` *(string)*
      - `read_only` *(boolean)*
      - `visible` *(boolean)*

##### Text Area

  - **if `dynamic` is not checked:**
    - `default_value` *(string)*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `required` *(boolean)*
    - `read_only` *(boolean)*
    - `validator_type` *('regex' (string) / false (boolean))*
    - `validator_rule` *(string; only if `validatior_type` has a value `'regex'`)*
    - `visible` *(boolean)*
  - **if the field is `dynamic`:**
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `load_values_on_init` *(boolean)*
    - `required` *(boolean)*
    - `resource_action` *(path to automate method)*
    - `show_refresh_button` *(boolean)*
    - `validator_type` *('regex' (string) / false (boolean))*
    - `validator_rule` *(string; only if `validatior_type` has a value `'regex'`)*
    - **In *Overridable Options* tab:**
      - `default_value` *(string)*
      - `read_only` *(boolean)*
      - `visible` *(boolean)*

##### Check Box

  - **if `dynamic` is not checked:**
    - `default_value` *(boolean)*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `required` *(boolean)*
    - `read_only` *(boolean)*
    - `visible` *(boolean)*
  - **if the field is `dynamic`:**
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `load_values_on_init` *(boolean)*
    - `required` *(boolean)*
    - `resource_action` *(path to automate method)*
    - `show_refresh_button` *(boolean)*
    - **In *Overridable Options* tab:**
      - `read_only` *(boolean)*
      - `visible` *(boolean)*

##### Date Control

  - **if `dynamic` is not checked:**
    - `default_value` *(Date object, after [#373](https://github.com/ManageIQ/ui-components/pull/373/files))*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `required` *(boolean)*
    - `read_only` *(boolean)*
    - `show_past_dates` *(boolean)*
    - `visible` *(boolean)*
  - **if the field is `dynamic`:**
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `options.show_past_dates` *(boolean)*
    - `required` *(boolean)*
    - `resource_action` *(path to automate method)*
    - `show_refresh_button` *(boolean)*
    - **In *Overridable Options* tab:**
      - `read_only` *(boolean)*
      - `visible` *(boolean)*

##### Date Time Control

  - **if `dynamic` is not checked:**
    - `default_value` *(Date object, after [#373](https://github.com/ManageIQ/ui-components/pull/373/files))*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `required` *(boolean)*
    - `read_only` *(boolean)*
    - `show_past_dates` *(boolean)*
    - `visible` *(boolean)*
  - **if the field is `dynamic`:**
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `options.show_past_dates` *(boolean)*
    - `required` *(boolean)*
    - `resource_action` *(path to automate method)*
    - `show_refresh_button` *(boolean)*
    - **In *Overridable Options* tab:**
      - `read_only` *(boolean)*
      - `visible` *(boolean)*

##### Dropdown List

  - **if `dynamic` is not checked:**
    - `data_type` *(select - string / integer)*
    - `default_value` *(string, or a string representing an array for multiselect -- `default_value: "[\"1\", \"2\"]"`)*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `options.force_multi_value` *(boolean)*
    - `options.sort_by` *(select - none / value / description)*
    - `options.sort_order` *(select - ascending / descending)*
    - `required` *(boolean)*
    - `read_only` *(boolean)*
    - `visible` *(boolean)*
    - `values` *(array, [0] - value, [1] - key)*
  - **if the field is `dynamic`:**
    - `data_type` *(select - string / integer)*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `load_values_on_init` *(boolean)*
    - `options.force_multi_value` *(boolean)*
    - `required` *(boolean)*
    - `resource_action` *(path to automate method)*
    - `show_refresh_button` *(boolean)*
    - **In *Overridable Options* tab:**
      - `options.sort_by` *(select - none / value / description)*
      - `options.sort_order` *(select - ascending / descending)*
      - `read_only` *(boolean)*
      - `visible` *(boolean)*

##### Radio Button

  - **if `dynamic` is not checked:**
    - `data_type` *(select - string / integer)*
    - `default_value` *(string or array for multiselect)*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `options.sort_by` *(select - none / value / description)*
    - `options.sort_order` *(select - ascending / descending)*
    - `required` *(boolean)*
    - `read_only` *(boolean)*
    - `visible` *(boolean)*
    - `values` *(array, [0] - value, [1] - key)*
  - **if the field is `dynamic`:**
    - `data_type` *(select - string / integer)*
    - `dialog_field_responders` *(multiple select - dynamic fields list)*
    - `load_values_on_init` *(boolean)*
    - `required` *(boolean)*
    - `resource_action` *(path to automate method)*
    - `show_refresh_button` *(boolean)*
    - **In *Overridable Options* tab:**
      - `options.sort_by` *(select - none / value / description)*
      - `options.sort_order` *(select - ascending / descending)*
      - `read_only` *(boolean)*
      - `visible` *(boolean)*

##### Tag Control

- `data_type` *(select - string / integer)*
- `dialog_field_responders` *(multiple select - dynamic fields list)*
- `options.category_id` *(select - list of categories)*
- `options.force_single_value` *(boolean)*
- `options.sort_by` *(select - none / value / description)*
- `options.sort_order` *(select - ascending / descending)*
- `required` *(boolean)*
- `read_only` *(boolean)*
- `visible` *(boolean)*


**A [note](https://github.com/ManageIQ/ui-components/pull/392#discussion_r296871830) by @eclarizio related to accessing values of the fields:*

> on the ui-components side for most of the field types,
> `default_value` is the value that is getting passed back from the
> refresh API call that we should be looking at to determine what to
> show to the user after a refresh happens. We changed it in
> [7dcb1f7](https://github.com/ManageIQ/ui-components/commit/7dcb1f7ca9fc404588cfd8944796bd3ed726c376).
> For sorted items, `values` is the key we use since it needs to be a
> list, and `default_value` is simply the one that is selected from that
> list.
>
> On the ui-components side, because of the way datetime controls work,
> there is special logic for the date and time parts because the
> `default_value` comes in as a string (because it is just a JSON
> response), and then it gets parsed and separated into a `dateField`
> and a `timeField` since the controls are separate.

### Toolbox

[`dialog-editor-field-static`](https://github.com/ManageIQ/ui-components/tree/master/src/dialog-editor/components/toolbox) is the component used for dragging the Dialog Fields placeholders into the droppable Dialog Group.

Its controller describes default values for parameters of each Dialog Field.

### Tree Selector and Tree View

Components [Tree Selector](https://github.com/ManageIQ/ui-components/tree/master/src/tree-selector) and [Tree View](https://github.com/ManageIQ/ui-components/tree/master/src/tree-view) are set to be replaced by [react-wooden-tree](https://github.com/brumik/react-wooden-tree).

In the Dialog Editor text boxes are used for selecting path to Automate methods using [Dialog Editor HTTP service](https://github.com/ManageIQ/manageiq-ui-classic/blob/36522ada53a64a129cb3519b4183da8084dced1c/app/assets/javascripts/services/dialog_editor_http_service.js#L15-L26) to lazy-load Automate methods.

## Angular Services

### Dialog Editor

The [`DialogEditor`](https://github.com/ManageIQ/ui-components/blob/master/src/dialog-editor/services/dialogEditorService.ts) service's primary use is to store the data of the edited dialog in the `setData` function:

```javascript
public setData(data: any) {
  this.data = data;
  // the dialog data are now stored in this.data.content[0]
  // as indicated earlier in the document
  ...
}
```

The `setData` function is then called in [Dialog Editor controller](https://github.com/ManageIQ/manageiq-ui-classic/blob/62c50e0af7324eee16bc333b65d801e4398a5674/app/assets/javascripts/controllers/dialog_editor/dialog_editor_controller.js#L86)

Another often used function is `public updatePositions(elements: any[])` used to re-calculate indexes of items in the dialog after a change of their position.

The Dialog Editor also uses [sessionStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage) to protect the users from mistakenly losing the changes while editing the dialog. In the `sessionStorage` the dialogs are stored by identificator `'service_dialog-' + id`.

```javascript
public clearSessionStorage(id: string) {
  sessionStorage.removeItem(this.sessionStorageKey(id));
}

public backupSessionStorage(id: string, dialog: any) {
  sessionStorage.setItem(this.sessionStorageKey(id), JSON.stringify(dialog));
}

public restoreSessionStorage(id: string) {
  return JSON.parse(sessionStorage.getItem(this.sessionStorageKey(id)));
}
```

### Dialog Editor Validation

The [`DialogValidation`](https://github.com/ManageIQ/ui-components/blob/master/src/dialog-editor/services/dialogValidationService.ts) service contains set of rules that needs to be fulfilled in order to be able to submit the Dialog.

The rules are:
 - rules for Dialog:
	 - Dialog needs to have a label
	 - Dialog needs to have at least one tab
 - rules for Dialog Tabs:
	 - Dialog tab needs to have a label
	 - Dialog tab needs to have at least one group
 - rules for Dialog Groups:
	 - Dialog group needs to have a label
	 - Dialog group needs to have at least one field
 - rules for Dialog Fields:
	 - Dialog field needs to have a name
	 - Dialog field needs to have a label
	 - Dropdown needs to have entries
	 - Category needs to be set for TagControl field
	 - Entry Point needs to be set for Dynamic elements
	 - If the value is set as Integer, entered values must be a number

## Workflow

### Launch the action to open Dialog Editor

The Dialog Editor can be opened for three different actions - `edit`, `copy` or `new`.
If both `:id` and `:copy` keys are specified, action is `copy`. If the `:copy` key is missing, the action is `edit`, if ever `:id` is not present, a `new` Dialog is being created.
The behavior is described in [`miq_ae_customization_helper.rb`](https://github.com/ManageIQ/manageiq-ui-classic/blob/master/app/helpers/miq_ae_customization_helper.rb)

The top level component `%dialog-editor` is used in the [editor.html.haml](https://github.com/ManageIQ/manageiq-ui-classic/blob/master/app/views/miq_ae_customization/editor.html.haml) template, where the ID of the dialog is also stored by:

```haml
ManageIQ.angular.app.value('dialogIdAction', '#{ dialog_id_action.to_json }');
```

### Data from the API

Service Dialogs are serialized together from four database tables - [dialog](https://github.com/ManageIQ/manageiq/blob/master/app/models/dialog.rb), [dialog tab](https://github.com/ManageIQ/manageiq/blob/master/app/models/dialog_tab.rb), [dialog group](https://github.com/ManageIQ/manageiq/blob/master/app/models/dialog_group.rb), and [dialog fields](https://github.com/ManageIQ/manageiq/blob/master/app/models/dialog_field.rb). The data are serialized into a single object, before being passed to the Dialog Editor.

The data are loaded by [Dialog Editor HTTP service](https://github.com/ManageIQ/manageiq-ui-classic/blob/master/app/assets/javascripts/services/dialog_editor_http_service.js) from API by the request:
```javascript
return API.get('/api/service_dialogs/' + id + '?attributes=content,buttons,label');
```
or in case of a new Dialog, an empty dialog structure, defined  in [Dialog Editor controller](https://github.com/ManageIQ/manageiq-ui-classic/blob/62c50e0af7324eee16bc333b65d801e4398a5674/app/assets/javascripts/controllers/dialog_editor/dialog_editor_controller.js#L23-L35) is used:

```javascript
var dialogInitContent = {
  'content': [{
    'dialog_tabs': [{
      'label': __('New tab'),
      'position': 0,
      'dialog_groups': [{
        'label': __('New section'),
        'position': 0,
        'dialog_fields': [],
      }],
    }],
  }],
};
```

from the API the data are received from the method [`fetch_service_dialogs_content`](https://github.com/ManageIQ/manageiq-api/blob/e9ca3256ded6d026fe412c0815e1bb672ee0d4e1/app/controllers/api/service_dialogs_controller.rb#L19-L22):

```ruby
def fetch_service_dialogs_content(resource)
  target, resource_action = validate_dialog_content_params(params)
  resource.content(target, resource_action, true)
end
```

after JSON is loaded for dynamic fields, dialog_field_responders needs to have an id, customized by: `translateResponderNamesToIds`.

### Submitting the Dialog

Before sumbitting the Dialog, a keys used by Angular need to be removed from the object describing the Dialog content. For that a [`customizer`](https://github.com/ManageIQ/manageiq-ui-classic/blob/62c50e0af7324eee16bc333b65d801e4398a5674/app/assets/javascripts/controllers/dialog_editor/dialog_editor_controller.js#L94-L116) function is used.

After, the Dialog is saved by calling:

```javascript
return API.post('/api/service_dialogs' + id, { action: action, resource: data }, { skipErrors: [400] });
```

## Demo

To play with the Dialog Editor and see what the JSON object of the dialog looks like, you can run [ui-components](https://github.com/ManageIQ/ui-components) and play with the Dialog Editor at http://localhost:4000/#/dialog/editor but please remember that

_The demo is not connected to a real instance and there is no way to connect dynamic fields to Automate methods in it._
