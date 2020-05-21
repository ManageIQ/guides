## Forms

The recommended way of writing ManageIQ UI forms is using [Data Driven Forms](https://data-driven-forms.org/).

Historically, ManageIQ UI still has rails forms and angular forms, for information about those, please see [the wiki](https://github.com/ManageIQ/manageiq-ui-classic/wiki/Forms-%28kinds%29).

---

ManageIQ UI imports data driven forms and exposes a `@@ddf` webpack alias for both local and plugin imports.

For data driven form specific details, please consult [ddf documentation](https://data-driven-forms.org/).

For an example of a data driven form used in a ManageIQ plugin, see [ManageIQ/manageiq-providers-redfish#107](https://github.com/ManageIQ/manageiq-providers-redfish/pull/107).



### Minimal example


`MiqFormRenderer` is our wrapper around DDF with our custom components and implicitly translated button labels.
For more information see the [component definition](https://github.com/ManageIQ/manageiq-ui-classic/blob/master/app/javascript/forms/data-driven-form.jsx).

`componentTypes` ([list](https://github.com/data-driven-forms/react-forms/blob/master/packages/react-form-renderer/src/files/component-types.js))
and `validatorTypes` ([list](https://github.com/data-driven-forms/react-forms/blob/master/packages/react-form-renderer/src/files/validator-types.js))
are a set of constants provided by DDF for creating a schema.

A DDF form consists of 2 parts:

* schema - essentially an array of field definitions, possibly dynamically generated (forms with conditional fields, etc.)
* a react component using the schema, MiqFormRenderer, and a backend (API) endpoint to talk to the server


```js
import React from 'react';
import PropTypes from 'prop-types';
import MiqFormRenderer, { componentTypes, validatorTypes } from '@@ddf';

const createSchema = ({ showDescription }) => ({
  fields: [
    // a static, required input with validation
    {
      component: componentTypes.TEXT_FIELD,
      name: 'name',
      label: __('Name'),

      isRequired: true,
      validate: [{
        type: validatorTypes.REQUIRED,
        message: __('Required'),
      }],
    },

    // dynamic textarea
    showDescription && {
      component: componentTypes.TEXTAREA_FIELD,
      name: 'description',
      label: __('Description'),
    },
  ],
});

export const MyForm = ({ initialValues, onSubmit, onCancel, showDescription }) => (
  <MiqFormRenderer
    initialValues={ initialValues }
    schema={ createSchema({ showDescription }) }
    onSubmit={ (values) => onSubmit(values) }
    onCancel={ () => onCancel() }
  />
);

MyForm.propTypes = {
  initialValues: PropTypes.shape({
    name: PropTypes.string,
    description: PropTypes.string,
  }),
  onSubmit: PropTypes.func.isRequired,
  onCancel: PropTypes.func.isRequired,
  showDescription: PropTypes.bool,
};
```

you would also need a `ManageIQ.component.addReact('forms.MyForm', MyForm);` in `component-definitions-common.js`.
