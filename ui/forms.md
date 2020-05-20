## Forms

The recommended way of writing ManageIQ UI forms is using [Data Driven Forms](https://data-driven-forms.org/).

Historically, ManageIQ UI still has rails forms and angular forms, for information about those, please see [the wiki](https://github.com/ManageIQ/manageiq-ui-classic/wiki/Forms-%28kinds%29).

---

Manageiq UI imports data driven forms and exposes a `@@ddf` webpack alias for both local and plugin imports.

For data driven form specific details, please consult [ddf documentation](https://data-driven-forms.org/).

For an example of a data driven form used in a ManageIQ plugin, see [ManageIQ/manageiq-providers-redfish#107](https://github.com/ManageIQ/manageiq-providers-redfish/pull/107).
