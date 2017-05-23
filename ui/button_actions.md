### Button Actions

Toolbar button actions can be server-side or client-side.

Currently most buttons are server-side but the preferred way of writing new
code is calling the API from client-side button actions.

#### Server-side Button Actions

When a toolbar button is pressed current controller's `button` or `x_button`
method is called.

The identifier of the button that was pressed is passed in `params[:pressed]`.

The `x_button` or `button` handlers should follow this pattern:

```
 def x_button
   generic_x_button(AE_CUSTOM_X_BUTTON_ALLOWED_ACTIONS)
 end
```

Meaning that just a lookup in the list of valid actions for the controller is
done and the action is called if found. Nothing else.

Cleaning up the handlers to this form will allow us to do furter refactorings
and make the button actions plugable.

#### Client-side Button Actions
In [Toolbars and Buttons](toolbars.md#javascript-only-buttons) you can see how to define javascript-only buttons.

Such button can perform changes in the UI or it can call the ManageIQ REST API
to get work done. See [Calling the API](calling_api.md).
