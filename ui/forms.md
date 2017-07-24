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
    * render the form (`app/views/foo/

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

`app/controllers/foo_controller.rb`

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


`app/views/foo/_form.html.haml`

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


`app/views/foo/_dynamic.html.haml`

```haml
= @edit[:current][:choice]
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


