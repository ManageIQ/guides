### Menus

The menu system allows definition of multiple menus. Currently we use two:

* Main menu
* Top right menu

Each menu consists of menu sections and menu items. Menu sections can contain other menu sections and menu items.

The main menu styling supports 3 level, that is 2 levels of menu section. Menus are defined in ``app/presenters/menu/default_menu.rb``

#### Menu Sections

```
Menu::Section.new(:clo, N_("Clouds"), 'fa fa-plus fa-2x', [
```

Menu sections looks like the example above. It consists of:
 * Identifier,
 * text,
 * icon and
 * items.

Identifier is the same as the [RBAC feature](rbac_features.md) that is checked when a decision is made whether or not the particular section is displayed.

Text needs to be marked for translation but not translated at the time of definition, therefor ``N_`` see [I18n](i18n.md)

Menu section structure (tree) forms the base of the RBAC tree that is available in the Role Editor. (See [RBAC features](rbac_features.md).)

Available menu section can be further limited on an appliance via PermissionStores. The YAML permission store checks the menu section identifier against a list of supported RBAC features effectively limiting what is available.

Items are a list of sections and items.

#### Menu Items

```
Menu::Item.new('miq_policy', N_('Explorer'), 'control_explorer', {:feature => 'control_explorer_view'}, '/miq_policy/explorer'),
```

Menu item consists of:
 * **Identifier**,
 * **text**,
 * **feature**,
 * **rbac\_feature hash**,
 * **href**,
 * **type**

Identifier is used to identify menu items e.g. for styling the active menu item.

Text is similar to text in menu sections. It can also be a Proc to allow run-time altering of the displayed text.

Feature key is used in parent section calculation such as visibility of the parent section.

Rbac\_feature is a hash that is passed to `role_allows?` call when decision is being made about displaying the menu item. In most cases, this is would contain just the key `:feature` that will match the feature.

Href is the URL that is opened when a menu item is clicked.

Type can be either :default or :big\_iframe. We stick with the :default type which is default. The :big\_iframe type is used for [simple UI plugins](simple_ui_plugins.md).

#### Remembering last clicks

Each menu section remembers last GET request that was done "under" that menu
section. Then if a user clicks a menu section (not a menu item) the last
remembered GET request's URL is opened so that the user lands where he last was "under" that menu section.

This requires a relationship between controller and menu section.

This relationship is declared by specifying the menu section in each controller
whose GET request should be remembered under a menu section:

```
class FoobarController < ApplicationController
  menu_section :opt
...
```

