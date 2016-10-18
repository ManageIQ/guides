### RBAC features

RBAC features are defined in `db/fixtures/miq_product_features.yml`. These are
organized in a tree structure that can be seen in the Role editor under
Settings.

RBAC features are assigned to roles. For the built-in roles this is predefined in `db/fixtures/miq_user_roles.yml`.

RBAC checking is done in for every action and every button `check_privileges`
in `ApplicationController`. Therefor each button, each menu item and each
screen needs to have it's RBAC feature.

More detailed RBAC checking is done in individual actions both in the UI and the API.
