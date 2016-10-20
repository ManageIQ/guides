### Button Actions

When a toolbar button is pressed current controller's `button` or `x_button` method is called. This is tru with the exception of some client-side only actions.

The identifier of the button that was pressed is passed in `params[:pressed]`.

The `x_button` or `button` handlers should follow this pattern:

```
 def x_button
   generic_x_button(AE_CUSTOM_X_BUTTON_ALLOWED_ACTIONS)
 end
```

Meaning that just a lookup in the list of valid actions for the controller is done and the action is called if found. Nothing else.

Cleaning up the handlers to this form will allow us to do furter refactorings and make the button actions plugable.
