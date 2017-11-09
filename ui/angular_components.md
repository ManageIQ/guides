### Angular Component

Location: `app/assets/javascripts/components`. 

#### Basic pattern
A component shouldn't modify any data or DOM that's out of its scope. All communication should go via bindings. One-way binding should be preferred over two-way binding.  
Set `controllerAs: "vm"`.  
`templateUrl:` should be preferred over `template:` but at the moment it's impossible to test that component's HTML is generated correctly if `templateUrl:` is used. So temporarily `template:` should be used instead of `templateUrl:`. 

#### `miq-button`
Component for a button element. 
```
%miq-button{:name      => t = _('Cancel'),
            :title     => t,
            :alt       => t,
            :enabled   => "true",
            'on-click' => "cancelClicked()"}
```
```
%miq-button{:name          => t = _('Validate'),
            :enabledTitle  => validate_title_on,
            :disabledTitle => validate_title_off,
            :enabled       => "true",
            'on-click'     => "cancelClicked(),
            :primary       => "true"}
```

It consists of:
* `name` (String) sets text shown in the button.
* `enabled` (expression) sets button to enabled or disabled.
* `enabledTitle` (String, optional) used if button has different title/alt for enabled and disabled state. Sets title/alt for enabled button. If `enabledTitle` is set `disabledTitle` should be set as well.
* `disabledTitle` (String, optional) used if button has different title/alt for enabled and disabled state. Sets title/alt for disabled button. If `disabledTitle` is set `enabledTitle` should be set as well.
* `primary` (expression, optional) True if button has class `btn-primary` otherwise it will have class `btn-default`.
* `onClick` (function) is a callback to be called when button is clicked.

If `title`/`alt` are the same for both states, `title` and `alt` should be set as attributes of the button. 
