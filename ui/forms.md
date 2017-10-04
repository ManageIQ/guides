## Forms

This attempts to document the state of forms in ui-classic, including all the stages of conversion, from pure rails to Angular.

Each stage's description should contain:

  * the main characteristics of such a form with pointers where to look
  * the list of actions involved during the form's lifecycle
  * a code example of a minimal form with
    * one text input validated for length
    * one select, the choice in which updates a useless message div
    * the default form buttons
  * a recommended migration path


### Stage 1 - the Rails way

#### characteristics

  * the whole form is rendered in Rails
  * each input field's `value` attribute is pre-filled with the existing object's data if editing
  * form data is stored server-side, in `session[:edit]` (which becomes `@edit`)
  * each change triggers a POST request to `form_field_changed` (sometimes prefixed), which updates the session
    * on the client side, this happens via the `miq_observe` jQuery plugin (`data-miq_observe`)
    * *except* for new selects, where we use the js function `miqSelectPickerEvent`, right after `miqInitSelectPicker`
    * these also handle re-rendering the form buttons (`buttons_on` vs. `buttons_off` via `javascript_show` and `javascript_hide` ruby-side) when the form becomes submittable (*some* validation, but usually just compares `@edit[:new]` to `@edit[:current]` to see if something `changed`)
    * such change requests may re-render the form or parts of it (eg. a select's value change triggers an additional fieldset to be added)
  * submitting a form triggers a POST request to `create` or `update`, but submits just the button name, no data
    * some validation usually happens here, and can render a flash message ruby-side (`add_flash` & `render_flash`)
    * success usually triggers a redirect to `show_list`/`explorer` in response, but sometimes also `replace_right_cell`
  * *some* forms also use tabs, tab change also propagates to the server and replaces the current tab with a new one


#### actions

Many of these action names will be prefixed with an entity type or a form name in real code (especially in explorer controllers with multiple entities) but not all of them. This is also true for the names of haml partials. In some rarer cases, suffixes or infixes are used instead (all of `foo_form_field_changed`, `form_field_changed_foo`, `form_foo_field_changed`, `form_field_changed` and `foo_field_changed` exist).

For simplicity, I'm omitting any such afixes and using a `foo_` prefix when complete omission would be confusing.


  * open a new/edit form - prefixed with entity type, `new` or `edit`
    * calls `set_form_vars`
      * loads data from db
      * populates `@edit`
    * renders the form (`app/views/foo/_form.html.haml`)

  * change a field - `form_field_changed`
    * calls `get_form_vars`
      * loads `@edit` from session
      * updates from `params`
    * checks for changes
    * updates form buttons (enabled/disabled)
    * renders any partils

  * save - `create` or `update`
    * calls `set_record_vars`
      * updates the actual record from session
    * form validations
    * flash message on fail
    * actually creates/updates the model on success
    * redirects elsewhere

  * cancel & reset - handled by the same `create` or `update`


#### code

##### app/controllers/foo_controller.rb

```ruby
def foo_new
  assert_privileges('foo_new')
  @record = Model.new
  foo_new_edit
end

def foo_edit
  assert_privileges('foo_edit')
  @record = find_record_with_rbac(Model, from_cid(params[:id]))
  foo_new_edit
end

def foo_new_edit
  set_form_vars
  @in_a_form = true
  session[:changed] = @changed = false
  replace_right_cell
end

def set_form_vars
  @edit = {}
  @edit[:id] = @record.id

  @edit[:new] = {}
  @edit[:current] = {}

  @edit[:new][:name] = @record.name
  @edit[:new][:choice] = @record.choice

  @choices = [["bar", "Bar"], ["baz", "Baz"]]

  @edit[:current] = copy_hash(@edit[:new])
end


def form_field_changed
  return unless load_edit("foo_edit__#{params[:id]}")
  get_form_vars

  session[:changed] = @changed = (@edit[:new] != @edit[:current])

  render :update do |page|
    page << javascript_prologue
    page.replace_html('dynamic_div', r[:partial => "dynamic"]) if params[:choice]
    page << javascript_for_miq_button_visibility(changed)
  end
end

def get_form_vars
  @edit[:new][:name] = params[:name] if params[:name]
  @edit[:new][:choice] = params[:choice] if params[:choice]
end


def foo_create
  assert_privileges('foo_new')
  @record = Model.new
  create_update
end

def foo_update
  assert_privileges('foo_edit')
  @record = find_record_with_rbac(Model, from_cid(params[:id]))
  create_update
end

def create_update
  return unless load_edit("foo_edit__#{params[:id]}")

  case params[:button]
  when 'cancel'
    add_flash(_("Cancelled"))
    @record = nil
    replace_right_cell

  when 'add', 'save'
    validate
    set_record_vars

    if @flash_array.nil? && @record.save
      add_flash(_('Saved'))
      @edit = nil
      replace_right_cell
    else
      javascript_flash
    end

  when 'reset', nil
    if params[:button] == 'reset'
      @edit[:new] = copy_hash(@edit[:current])
      add_flash(_('All changes have been reset'))
    end

    replace_right_cell
  end
end

def set_record_vars
  @record[:name] = @edit[:new][:name]
  @record[:choice] = @edit[:new][:choice]
end

def validate
  add_flash(_("Name must be shorter than 16 characters"), :error) if @edit[:new][:name].length >= 16

  add_flash(_("A choice is required"), :error) unless @edit[:new][:choice]
end
```


##### app/views/foo/_form.html.haml

```haml
- url = url_for_only_path(:action => "form_field_changed", :id => @record.id || "new")

#form_div
  = render :partial => "layouts/flash_msg"

  %h3
    = _("Foo")

  .form-horizontal
    .form-group
      %label.col-md-2.control-label
        = _('Name')
      .col.md-8
        = text_field_tag('name',
                         @edit[:new][:name],
                         :class             => 'form-control',
                         'data-miq_observe' => {:url => url}.to_json)

    .form-group
      %label.col-md-2.control-label
        = _('Choice')
      .col.md-8
        = select_tag('choice',
                     options_for_select([["<#{_('Choose')}>", nil]] + @choices),
                     "data-miq_sparkle_on" => true,
                     :class                => "selectpicker")
        :javascript
          miqInitSelectPicker();
          miqSelectPickerEvent('choice', '#{url}')

    #dynamic_div
      = render :partial => "dynamic"
```


##### app/views/foo/_dynamic.html.haml

```haml
- if @edit[:current][:choice] === "foo"
  = _("This could be a few more inputs")

- if @edit[:current][:choice] === "bar"
  = _("Or just a harmless message")
```


#### migration

A recommended migration from here is to go to the newest version which already exists:

  * don't want to reimplement the wheel together with the migration
  * but this involves a rewrite of most of actual code involved (ruby to js) so it does not make sense to rewrite to the oldest angular form

The idea is to:

  * stop the view from having anything to do with actual form state:
    * it should render to the full html of all the bits of the form that can exist
      * the view should live under `app/views/static/` - rendered server-side, with i18n, but without any form state
    * conditional visibility should be achived via Angular directives
  * provide a data-only JSON endpoint to query for the object's data
    * unless such already exists in the API or is not special enough not to try to implement there instead (these are often needed, but always create tech debt)
  * write an angular component which:
    * takes an id parameter (empty when new)
    * queries the server for the data (if editing)
      * later this will be done in the router
    * keeps all the form state in it's model object
    * does all the validation that makes sense
    * submits that object on save
    * doesn't talk to the server unless it has to
  * replace the original view with the use of such a component, with any necessary options coming from server-side
  * handle only the initial rendering, data, and submit/cancel ruby side



### Stage 2 - Angular conversion from before 1.5

#### characteristics

  * (all the changes from ruby TODO)
  * uses $scope
  * oftern still actually submits the form the old way
  * TODO


#### actions

TODO


#### code

##### app/controllers/foo_controller.rb

```ruby
def foo_new
  assert_privileges('foo_new')
  @record = Model.new
  @in_a_form = true
  replace_right_cell
end

def foo_edit
  assert_privileges('foo_edit')
  @record = find_record_with_rbac(Model, from_cid(params[:id]))
  @in_a_form = true
  replace_right_cell
end


def foo_create
  assert_privileges('foo_new')
  @record = Model.new
  create_update
end

def foo_update
  assert_privileges('foo_edit')
  @record = find_record_with_rbac(Model, from_cid(params[:id]))
  create_update
end

def create_update
  TODO this changes

  case params[:button]
  when 'cancel'
    javascript_redirect(:action    => 'show_list',
                        :flash_msg => _("Add of new %{model} was cancelled by the user"))

  when 'add', 'save'
    set_record_vars

    if @record.valid && @record.save
      add_flash(_('Saved'))
      @edit = nil
      replace_right_cell
    else
      TODO flash co
      javascript_flash
    end
end

def set_record_vars
  @record[:name] = params[:name] if params.key?(:name)
  @record[:choice] = params[:choice] if params.key?(:choice)
end
```


##### app/assets/javascripts/controllers/foo/foo_form_controller.js

```js
TODO
ManageIQ.angular.app.controller('hostFormController', ['$http', '$scope', '$attrs', 'hostFormId', 'miqService', function($http, $scope, $attrs, hostFormId, miqService) {
  var init = function() {
    $scope.hostModel = {
      name: '',
      hostname: '',
      ipmi_address: '',
      custom_1: '',
      user_assigned_os: '',
      operating_system: false,
      mac_address: '',
      default_userid: '',
      default_password: '',
      remote_userid: '',
      remote_password: '',
      ws_userid: '',
      ws_password: '',
      ipmi_userid: '',
      ipmi_password: '',
      validate_id: '',
    };

    $scope.modelCopy = angular.copy( $scope.hostModel );
    $scope.afterGet = false;
    $scope.formId = hostFormId;
    $scope.validateClicked = miqService.validateWithAjax;
    $scope.formFieldsUrl = $attrs.formFieldsUrl;
    $scope.createUrl = $attrs.createUrl;
    $scope.updateUrl = $attrs.updateUrl;
    $scope.model = "hostModel";
    ManageIQ.angular.scope = $scope;

    if (hostFormId == 'new') {
      $scope.newRecord = true;
      $scope.hostModel.name = "";
      $scope.hostModel.hostname = "";
      $scope.hostModel.ipmi_address = "";
      $scope.hostModel.custom_1 = "";
      $scope.hostModel.user_assigned_os = "";
      $scope.hostModel.operating_system = false;
      $scope.hostModel.mac_address = "";
      $scope.hostModel.default_userid = "";
      $scope.hostModel.default_password = "";
      $scope.hostModel.remote_userid = "";
      $scope.hostModel.remote_password = "";
      $scope.hostModel.ws_userid = "";
      $scope.hostModel.ws_password = "";
      $scope.hostModel.ipmi_userid = "";
      $scope.hostModel.ipmi_password = "";
      $scope.hostModel.validate_id = "";
      $scope.afterGet = true;
    } else if (hostFormId.split(",").length == 1) {
        miqService.sparkleOn();
        $http.get($scope.formFieldsUrl + hostFormId)
          .then(getHostFormDataComplete)
          .catch(miqService.handleFailure);
     } else if (hostFormId.split(",").length > 1) {
      $scope.afterGet = true;
    }

     $scope.currentTab = "default";
  };

  $scope.changeAuthTab = function(id) {
    $scope.currentTab = id;
  }

  $scope.addClicked = function() {
    miqService.sparkleOn();
    var url = 'create/new' + '?button=add';
    miqService.miqAjaxButton(url, true);
  };

  $scope.cancelClicked = function() {
    miqService.sparkleOn();
    if (hostFormId == 'new') {
      var url = $scope.createUrl + 'new?button=cancel';
    } else if (hostFormId.split(",").length == 1) {
      var url = $scope.updateUrl + hostFormId + '?button=cancel';
    } else if (hostFormId.split(",").length > 1) {
      var url = $scope.updateUrl + '?button=cancel';
    }
    miqService.miqAjaxButton(url);
  };

  $scope.saveClicked = function() {
    miqService.sparkleOn();
    if (hostFormId.split(",").length > 1) {
      var url = $scope.updateUrl + '?button=save';
    } else {
      var url = $scope.updateUrl + hostFormId + '?button=save';
    }
    miqService.miqAjaxButton(url, true);
  };

  $scope.resetClicked = function() {
    $scope.$broadcast ('resetClicked');
    $scope.hostModel = angular.copy( $scope.modelCopy );
    $scope.angularForm.$setUntouched(true);
    $scope.angularForm.$setPristine(true);
    miqService.miqFlash("warn", __("All changes have been reset"));
  };

  $scope.isBasicInfoValid = function() {
    if(($scope.currentTab == "default") &&
      ($scope.hostModel.hostname || $scope.hostModel.validate_id) &&
      ($scope.hostModel.default_userid != '' && $scope.angularForm.default_userid.$valid &&
      $scope.angularForm.default_password.$valid)) {
      return true;
    } else if(($scope.currentTab == "remote") &&
      ($scope.hostModel.hostname || $scope.hostModel.validate_id) &&
      ($scope.hostModel.remote_userid != '' && $scope.angularForm.remote_userid.$valid &&
      $scope.angularForm.remote_password.$valid)) {
      return true;
    } else if(($scope.currentTab == "ws") &&
      ($scope.hostModel.hostname || $scope.hostModel.validate_id) &&
      ($scope.hostModel.ws_userid != '' && $scope.angularForm.ws_userid.$valid &&
      $scope.angularForm.ws_password.$valid)) {
      return true;
    } else if(($scope.currentTab == "ipmi") &&
      ($scope.hostModel.ipmi_address) &&
      ($scope.hostModel.ipmi_userid != '' && $scope.angularForm.ipmi_userid.$valid &&
      $scope.angularForm.ipmi_password.$valid)) {
      return true;
    } else
      return false;
  };

  $scope.canValidate = function () {
    if ($scope.isBasicInfoValid() && $scope.validateFieldsDirty())
      return true;
    else
      return false;
  }

  $scope.canValidateBasicInfo = function () {
    if ($scope.isBasicInfoValid())
      return true;
    else
      return false;
  }

  $scope.validateFieldsDirty = function () {
    if(($scope.currentTab == "default") &&
      (($scope.angularForm.hostname.$dirty || $scope.angularForm.validate_id.$dirty) &&
      $scope.angularForm.default_userid.$dirty &&
      $scope.angularForm.default_password.$dirty)) {
      return true;
    } else if(($scope.currentTab == "remote") &&
      (($scope.angularForm.hostname.$dirty || $scope.angularForm.validate_id.$dirty) &&
      $scope.angularForm.remote_userid.$dirty &&
      $scope.angularForm.remote_password.$dirty)) {
      return true;
    } else if(($scope.currentTab == "ws") &&
      (($scope.angularForm.hostname.$dirty || $scope.angularForm.validate_id.$dirty) &&
      $scope.angularForm.ws_userid.$dirty &&
      $scope.angularForm.ws_password.$dirty)) {
      return true;
    } else if(($scope.currentTab == "ipmi") &&
      ($scope.angularForm.ipmi_address.$dirty &&
      $scope.angularForm.ipmi_userid.$dirty &&
      $scope.angularForm.ipmi_password.$dirty)) {
      return true;
    } else
      return false;
  }

  function getHostFormDataComplete(response) {
    var data = response.data;

    $scope.hostModel.name = data.name;
    $scope.hostModel.hostname = data.hostname;
    $scope.hostModel.ipmi_address = data.ipmi_address;
    $scope.hostModel.custom_1 = data.custom_1;
    $scope.hostModel.user_assigned_os = data.user_assigned_os;
    $scope.hostModel.operating_system = data.operating_system;
    $scope.hostModel.mac_address = data.mac_address;
    $scope.hostModel.default_userid = data.default_userid;
    $scope.hostModel.remote_userid = data.remote_userid;
    $scope.hostModel.ws_userid = data.ws_userid;
    $scope.hostModel.ipmi_userid = data.ipmi_userid;
    $scope.hostModel.validate_id = data.validate_id;

    if ($scope.hostModel.default_userid !== '') {
      $scope.hostModel.default_password = miqService.storedPasswordPlaceholder;
    }
    if ($scope.hostModel.remote_userid !== '') {
      $scope.hostModel.remote_password = miqService.storedPasswordPlaceholder;
    }
    if ($scope.hostModel.ws_userid !== '') {
      $scope.hostModel.ws_password = miqService.storedPasswordPlaceholder;
    }
    if ($scope.hostModel.ipmi_userid !== '') {
      $scope.hostModel.ipmi_password = miqService.storedPasswordPlaceholder;
    }

    $scope.afterGet = true;

    $scope.modelCopy = angular.copy( $scope.hostModel );
    miqService.sparkleOff();
  }

  init();
}]);

```


##### app/views/foo/_form.html.haml

```haml
- @angular_form = true

.form-horizontal
  %form#form_div{"name"            => "angularForm",
                 "ng-controller"   => "hostFormController",
                 'ng-cloak'        => '',
                 "ng-show"         => "afterGet",
                 "novalidate"      => true}

    = render :partial => "layouts/flash_msg"

    - if session[:host_items].nil?
      %div
        %div
          .form-group{"ng-class" => "{'has-error': angularForm.name.$invalid}"}
            %label.col-md-2.control-label{"for" => "name"}
              = _("Name")
            .col-md-8
              %input.form-control{"type"        => "text",
                                  "id"          => "name",
                                  "name"        => "name",
                                  "ng-model"    => "hostModel.name",
                                  "maxlength"   => "#{MAX_NAME_LEN}",
                                  "miqrequired" => "",
                                  "checkchange" => "",
                                  "auto-focus"  => ""}
              %span.help-block{"ng-show" => "angularForm.name.$error.miqrequired"}
                = _("Required")
          .form-group{"ng-class" => "{'has-error': angularForm.hostname.$invalid}"}
            %label.col-md-2.control-label{"for" => "hostname"}
              = _("Hostname (or IPv4 or IPv6 address)")
            .col-md-4
              %input.form-control{"type"        => "text",
                                  "id"          => "hostname",
                                  "name"        => "hostname",
                                  "ng-model"    => "hostModel.hostname",
                                  "maxlength"   => "#{MAX_HOSTNAME_LEN}",
                                  "miqrequired" => "",
                                  "checkchange" => ""}
              %span.help-block{"ng-show" => "angularForm.hostname.$error.miqrequired"}
                = _("Required")
          .form-group{"ng-class" => "{'has-error': angularForm.user_assigned_os.$invalid}", "ng-hide" => "hostModel.operating_system"}
            %label.col-md-2.control-label
              = _("Host platform")
            .col-md-8
              = select_tag('user_assigned_os',
                           options_for_select([["<#{_('Choose')}>", nil]] + Host.host_create_os_types.to_a, disabled: ["<#{_('Choose')}>", nil]),
                           "ng-model"                    => "hostModel.user_assigned_os",
                           "checkchange"                 => "",
                           "ng-required"                 => "!hostModel.operating_system",
                           "selectpicker-for-select-tag" => "")
              %span.help-block{"ng-show" => "angularForm.user_assigned_os.$error.required"}
                = _("Required")
          .form-group
            %label.col-md-2.control-label
              = _("Custom Identifier")
            .col-md-8
              %input#custom_1.form-control{"type"        => "text",
                                           "name"        => "custom_1",
                                           "ng-model"    => "hostModel.custom_1",
                                           "maxlength"   => 50,
                                           "checkchange" => ""}
          .form-group{"ng-class" => "{'has-error': angularForm.ipmi_address.$error.requiredDependsOn}"}
            %label.col-md-2.control-label{"for" => "ipmi_address"}
              = _("IPMI IP Address")
            .col-md-8
              %input.form-control#ipmi_address{"type"                => "text",
                                               "id"                  => "ipmi_address",
                                               "name"                => "ipmi_address",
                                               "ng-model"            => "hostModel.ipmi_address",
                                               "required-depends-on" => "hostModel.ipmi_userid",
                                               "required-if-exists"  => "ipmi_userid",
                                               "maxlength"           => 15,
                                               "checkchange"         => ""}
              %span.help-block{"ng-show" => "angularForm.ipmi_address.$error.requiredDependsOn"}
                = _("Required")
          .form-group
            %label.col-md-2.control-label
              = _("MAC Address")
            .col-md-8
              %input#mac_address.form-control{"type"        => "text",
                                              "name"        => "mac_address",
                                              "ng-model"    => "hostModel.mac_address",
                                              "maxlength"   => "#{MAX_NAME_LEN}",
                                              "checkchange" => ""}
    %hr
    = render(:partial => "/layouts/angular/multi_auth_credentials",
             :locals  => {:record => @host, :ng_model => "hostModel"})
    = render :partial => "layouts/angular/x_edit_buttons_angular"

  - unless session[:host_items].nil?
    %h3
      = n_("Host", "Hosts", session[:host_items].length)
      = _('Selected')
    = _('Click on a Host to fetch its settings')
    %table.admittable{:height => '75'}
      %tbody
        %tr
          %td
            - if session[:host_items]
              - @embedded = true
              - @gtl_type = settings(:views, :host)
              = render :partial => 'layouts/gtl'

:javascript
  ManageIQ.angular.app.value('hostFormId', '#{(@host.id || (session[:host_items] && session[:host_items].join(","))) || "new"}');
  miq_bootstrap('#form_div');
%form#form_div{'name' => 'angularForm', '
  = render :partial => "layouts/flash_msg"

  %h3
    = _("Foo")

  .form-horizontal
    .form-group
      %label.col-md-2.control-label
        = _('Name')
      .col.md-8
        = text_field_tag('name',
                         @edit[:new][:name],
                         :class             => 'form-control',
                         'data-miq_observe' => {:url => url}.to_json)

    .form-group
      %label.col-md-2.control-label
        = _('Choice')
      .col.md-8
        = select_tag('choice',
                     options_for_select([["<#{_('Choose')}>", nil]] + @choices),
                     "data-miq_sparkle_on" => true,
                     :class                => "selectpicker")
        :javascript
          miqInitSelectPicker();
          miqSelectPickerEvent('choice', '#{url}')

    #dynamic_div
      = render :partial => "dynamic"
```


##### app/views/foo/_dynamic.html.haml

```haml
%div{'ng-if' => 'choice == "foo"'}
  = _("This could be a few more inputs")

%div{'ng-if' => 'choice == "bar"'}
  = _("Or just a harmless message")
```


#### migration

TODO


(from https://github.com/ManageIQ/manageiq-ui-classic/pull/1997#discussion_r140758135 :)

Working on the guide, but for now, pretty much all you need to do is:

rename init to $onInit - that gets called automagically by angular, so you no longer need to call it manually.
move the templates under app/views/static/ - that way, you can reference it via templateUrl: '/static/....' from angular
remove any controller-dependent logic from the moved template - that just means you can't use @record.id in your case
make it into a component...
ManageIQ.angular.app.controller("foo", **controller**);
should become

ManageIQ.angular.app.component("foo", {
  bindings: {
    recordId: "@",
  }
  templateUrl: "/static/foo.html.haml",
  controller: **controller**,
});
then you no longer need to pass the id using value, you can provide it to the component as a parameter - hence the bindings entry - so no injecting vmCloudRemoveSecurityGroupFormId any more ;)
replace the original template with just something that uses the component .. so, %my-component{:record-id => @record.id}, and initializes angular (so that miq_bootstrap stays here, not in static - we usually use the component name as the first arg in those cases (so you don't need an extra #div))
don't leave the code in app/assets/javascripts/controllers, use the components dir for that - or if you're up to speed with the recent webpacker changes (talk), you can move it to app/javascript/ and use newer JS features.
EDIT: oh, and remove ng-controller from the template too

Also, that miqAjaxButton is an anti-pattern now, with angular components, you should no longer rely on the server generating javascript to redirect you/show a flash message/whatever... instead, you should be using render :json => ... in ruby, and read that json in JS to do the right thing.

(But, it's not miqAjaxButton(url, true) which is the worst, so.. if the server-side logic to do that is not trivial, feel free to ignore this bit for now.)
