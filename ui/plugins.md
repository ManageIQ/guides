### UI Plugins

The UI now supports plugins - rails engines that can be added to the Gemfile, and provide additional menu items and screens for the Classic UI.

For info on how to use a plugin, please see [Plugin development](../developer_setup/plugins.md).

(This section is a stub and will be expanded later. For now, please see (the v2v plugin)[https://github.com/ManageIQ/miq_v2v_ui_plugin] for a working example.)

This is *not* the same as [Simple plugins](simple_ui_plugins.md), which is an older feature using an iframe to point to a specific URL.

---

#### Shared libraries:

Since the plugins' javascript is built together with the rest of ui-classic, it needs to share certain common libraries - this is the list of shared libraries, guaranteed to be available to plugins now (but not in gaprindashvili):

* jquery
* lodash
* patternfly-sass (and window-shared dependencies, such as bootstrap-switch, bootstrap-select, etc.)
* patternfly-react
* react
* react-dom

(For the actual versions, please see our [package.json](https://github.com/ManageIQ/manageiq-ui-classic/blob/master/package.json).)

A plugin is free to add any additional dependencies of course.


If a plugin happens to depend on the same library in a different version:

* right now, you can't - either of the 2 versions will get picked, randomly
* after we update to webpack 5, you shouldn't - this would still mean downloading 2 copies of the library on every page load
