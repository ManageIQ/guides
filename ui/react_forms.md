## React Forms
This section documents how to create JS forms using React.

### Table of contents
- React-ui-components
- Dependencies
- Form API
- Form Field
- MIQ Form Components
- Examples
  - Simple form
  - Global form validation
  - Field level validation
  - Multiple validators
  - Passing data outside of the form

### React-ui-components
React-ui-components is is the source [repository](https://github.com/ManageIQ/react-ui-components) for react form components(and others) for MIQ. This repository is using patternfly 3 design and components. Most of the components are wrappers around PF3 components. Those components create interface between React components and [Form API](#FormAPI). Components (including forms) inside this repo should be generic and usefull in multiple project. If you have some generic form, or a small fragment of a form, it should be placed inside this repo. Otherwise its better idea to use it directly inside your project.

### Dependencies
To use form components, you need to add react-ui-components to your dependencies:
```bash
$ yarn add @manageiq/react-ui-components
```
As a form API we are using [React Final Form](https://github.com/final-form/react-final-form) library. This is not shipped with the react-ui-components package, because you might not want to use form components but something else and we want to ship the smallest package as possible. Therefor you will also have to add these dependencies
```bash
$ yarn add react-final-form final-form
```

###<a name="FormAPI"></a> Form API
As a form API we are using [React Final Form](https://github.com/final-form/react-final-form) library. Before reading anything else, it is recomended to go through their docs and examples. Also if you don't find some specific use-case or example here, it is possible it will be addressed in the official docs.

This API provides two main components: **Form** and **Field**. These are used to compose form components.
#### Form
The Form component is basically just a [React context](https://reactjs.org/docs/context.html), that provides data and functions to its children, mainly to the **Field** components.

To use this component, you have to add it to your file first:
```javascript
import { Form } from 'react-final-form'
```

Form has several props, but only **onSubmit** callback must be specified. The onSubmit callback provides the current **values** and the whole **formApi**. OnSubmit will be called if all values are valid. Further information can be found [here](https://github.com/final-form/final-form#onsubmit-values-object-form-formapi-callback-errors-object--void--object--promiseobject--void).
```javascript
import { Form } from 'react-final-form'
<Form onSubmit={(values, formApi) => console.log('Submited values: ', values)} />
```

Another important prop is **render**. This prop is used to create template of the form. You specify form children, but using the render method will result in cleaner code.

Following example is a simple form with one text input and submit button.
```javascript
import { Form, Field } from 'react-final-form'

<Form
  onSubmit={values => submitFunction(values)}
  render={({ handleSubmit }) => (
    <form onSubmit={handleSubmit}> // classic HTML5 form submit not required
      <div>
        <h1>Default input</h1>
        <div>
          <label>Name</label>
          <Field
            name="name"
            component="input"
            {...other HTML5 input props}
          />
        </div>
      </div>
      <button onClick={handleSubmit}>Submit</button>
    </form>
  )}
/>
```

FormApi provides usefull information about current form state. You can access them from the context or even better from **render parameters**. Full list of form state values can be found [here](https://github.com/final-form/final-form#formstate).

This example shows most commonly used state values:
```javascript
import { Form } from 'react-final-form'
<Form
  onSubmit={values => submitFunction(values)}
  render={({
    handleSubmit,
    reset,
    values,
    valid,
    invalid,
    pristine,
    dirty,
    submitFailed,
    errors,
    }) => {
      // some form template
  }}
/>
```
**handleSubmit**
- function defined in *onSubmit*  prop
- should be bound to submit button.

**reset**
- function that reset *formState* into its default state
- should be bound to reset button.

**values**
- values of form fields
- it is a object, where keys are the names (the *name* prop if Field component) of individual fields and values are current values of fields.
```javascript
{
  name: 'Thomas',
  password: 'very secure password'
  ...
}
```
- can be used for some dynamic form changes like showing new field when a certain values is equal to something: 
```javascript
...
{values.name === 'Andrew' && <Field name="andrews-field" {... other field props} />}
...
```

**valid**
- is `true` if the form has no validation errors
- can be used to enable/disable subbmit button.

**invalid**
- is `true` if the form has at least one validation error
- can be used to enable/disable subbmit button

**pristine**
- is `true` if the form is in its initial state
- can be used to enable/disable reset button

**dirty**
- is `true` if any of the form values is different from initial state.
- can be used to enable/disable reset button

**submitFailed**
- if `true` if the form subbmission failed.
- can be used for additional error handling

**errors**
- array of validation errors
- can be used for additional validation handling

#### Field

Field component is used to add form fields to your form. It provides interface between the form context and classic form components. You can also access the form context without this component, but it is not recomended. Detailed documentation for tthe Field component can be found [here](https://github.com/final-form/react-final-form#fieldprops).

In order to properly render your form field component, you need to specify two things: field **name** and what component should be rendered.

The **name** will be used to register the Fied into the form state.

There are several ways to pass information about field rendering. There is a set of default components, that can be rendered. These are just simple HTML5 form inputs like `<input>, <select>` etc. You can also render custom components. The only rule for rendering custom components is to pass **Field** `input` and `meta` props to the actual form control.

**Simple example**
```javascript
<Field name="default" component="input" /> // this will render default HTML input
```

**Custom component**
Custom component can be anything(not just input fields) as long as its uses the `onChange` callback provided by `Field` component.

#### Custom Field rendering
There are three ways how to render custom Components. Either pass a render function to a Field which returns React component, or pass a React component to the `component` Field prop or as a React children. In all cases, you will be provider with two objects `input` and `meta`. Input contains functions that are used for controlling the component and meta provides some meta information about the Field(like validation messages).
Every other prop added to Field component will be also passed to the custom component. 

The preferad way to render custom components in MIQ is use the `component` prop.

**Using the component prop**
```javascript
import { Field } from 'react-final-form'

const CustomTextField = ({ input, meta, ...rest }) => (
  <div className={`form-field ${meta.error ? 'invalid' : ''}`}>
    <label>{rest.label}</label>
    <input
      {...rest}
      type={rest.type}
      placeholder={rest.placeholder}
      {...input} 
      value={input.value} // is added to input via {...input} but it is very important to showcase
      onChange={(event, value) => input.onChange(value)} // override default input.onchage
    />
    {meta.eror && <label>{meta.error}</label>}
  </div>
)

<Field
  name="custom-input-field"
  component={CustomTextField}
  placeholder="Insert your value here!"
  type="number"
  label="Field label"
/>
```

**Using the render prop**
```javascript
import { Field } from 'react-final-form'

<Field
  name="render-input-field"
  type="text"
  label="Field label"
  render={({input, meta, ...rest}) => (    
    <div className={`form-field ${meta.error ? 'invalid' : ''}`}>
      <label>{rest.label}</label>
      <input
        {...rest}
        {...input} 
        value={input.value}
        onChange={(event, value) => input.onChange(value)}
      />
      {meta.eror && <label>{meta.error}</label>}
    </div>
  )}
/>

```

**Using the React children**
```javascript
import { Field } from 'react-final-form'

<Field
  name="render-input-field"
  type="text"
  label="Field label"
>
  {({input, meta, ...rest}) => (
    <div className={`form-field ${meta.error ? 'invalid' : ''}`}>
      <label>{rest.label}</label>
      <input
        {...rest}
        {...input} 
        onChange={(event, value) => input.onChange(value)}
      />
      {meta.eror && <label>{meta.error}</label>}
    </div>
  )}
</Field>

```


### MIQ Form Components
React-ui-components provides multiple custom Field components. Their look and feel is based on patternfly 3.

React-ui-components export multiple packages to further decrease the size of final build of your app. To import Form components:

```javascript
import {
  FinalFormField,
  FinalFormSelect,
  FieldGroup,
  FinalFormCheckBox,
  FinalFormRadio,
  FinalFormTextArea,
  FinalFormSwitch,
} from '@manageiq/react-ui-components/dist/forms';
```

#### FinalFormField
This component represents classic HTML5 `<input />`. Do not use this component for radiobutton or checkbox. These have dedicated components.

**Props**
|  prop name | type  | default | description |
|---|---|---|---|
|  label | `string`  | `undefined` | Label displayed next to the input |
| type | one of `['text', 'number', 'password', 'email']` | `'text'` | type of input |
| labelColumnSize | `number` | `2` | bs col-xs value |
| inputColumnSize | `number` | `8` | bs col-xs value |
| disabled | `bool` | `false` | Disables input changes |
| maxLength | `number` | `undefined` | Defines max value length |
| placeholder | `string` | `undefined` | Input placeholder |
| input| `object` | `undefined` | Input control functions. Is provided by `<Field />` component. |
|meta|`object`|`undefined`|Input meta informations. Is provided by `<Field />` component. |


**Usage**
```javascript
import { Field } from 'react-final-form';
import { FinalFormField } from '@manageiq/react-ui-components/dist/forms'

<Field
  name="final-form-field"
  type="text"
  placeholder="Insert text here"
  label="I am text field"
  labelColumnSize={4}
  inputColumnSize={3}
  component={FinalFormField}
/>
```

#### FinalFormSelect
Select form component. Uses the [ReactSelect v1](https://react-select.com/home) component.

**Props**
|prop name|type|default|description|
|---|---|---|---|---|
|  label | `string`  | `undefined` | Label displayed next to the select |
| labelColumnSize | `number` | `2` | bs col-xs value |
| inputColumnSize | `number` | `8` | bs col-xs value |
|options|`array[{value, label}]`| `undefined` | Options from which you can select|
|placeholder|`string`|`undefined`| Text displayed on select, when no option is selected|
| disabled | `bool` | `false` | Disables input changes |
|multi|`bool`|`false`|When `true` changes to multiselec variant|
|searchable| `bool`| `false`| When true enables searching in options|
|clearable|`bool`|`false`| When true shows button tha clears all selected options|
|input|`object`| `undefined` | Select control functions. Is provided by `<Field />` component. |
|meta|`object`|`undefined`|Select meta informations. Is provided by `<Field />` component. |

**Usage**
```javascript
import { Field } from 'react-final-form';
import { FinalFormSelect } from '@manageiq/react-ui-components/dist/forms'

<Field
  name="select-field"
  placeholder="Choose one or more options"
  label="Select input"
  component={FinalFormSelect}
  options={[{ value: 1, label: 'Option 1' }...]}
  multi
  clearable
  searchable
/>
```


#### FinalFormTextArea
Textarea form component.

**Props**
|prop name|type|default|description|
|---|---|---|---|---|
|  label | `string`  | `undefined` | Label displayed next to the input |
| labelColumnSize | `number` | `2` | bs col-xs value |
| inputColumnSize | `number` | `8` | bs col-xs value |
| placeholder | `string` | `undefined` | Input placeholder |
| disabled | `bool` | `false` | Disables input changes |
|input|`object`| `undefined` | Control functions. Is provided by `<Field />` component. |
|meta|`object`|`undefined`|Meta informations. Is provided by `<Field />` component. |

**Usage**
```javascript
import { Field } from 'react-final-form';
import { FinalFormTextArea } from '@manageiq/react-ui-components/dist/forms'

<Field
  name="texarea-field"
  placeholder="Write text here"
  component={FinalFormTextArea}
  label="Textarea"
/>
```

#### FinalFormSwitch
Switch/Toggle form component. Should be used for single `true/false` form values.

|prop name|type|default|description|
|---|---|---|---|---|
|  label | `string`  | `undefined` | Label displayed next to the input |
| labelColumnSize | `number` | `2` | bs col-xs value |
| inputColumnSize | `number` | `8` | bs col-xs value |
| disabled | `bool` | `false` | Disables input changes
|onText | `string`|`ON`|Text of switch on ON state|
|offText | `string`|`OFF`|Text of switch on OFF state|
|input|`object`| `undefined` | Control functions. Is provided by `<Field />` component. |
|meta|`object`|`undefined`|Meta informations. Is provided by `<Field />` component. |

PF3 is using boostrap switch. Rest of the component props is described [here](https://github.com/Julusian/react-bootstrap-switch).

**Usage**
```javascript
import { Field } from 'react-final-form';
import { FinalFormSwitch } from '@manageiq/react-ui-components/dist/forms'

<Field
  name="switch-field"
  component={FinalFormSwitch}
  label="Turn on?"
  onText="Yes"
  offText="No"
/>
```

#### FieldGroup
To use checkboxes/radiobuttons, you should group them together. If you want to have a single toggle field, please use the switch component.
Field group is used to style and handle selection sections of forms.

**Field group props**
|prop name|type|default|description|
|---|---|---|---|---|
|label|`string`|`undefined`|Label of the field group|
|name|`string`|`undefined`|Field group identifier|

#### Checkbox FieldGroup

**Checkbox props**
|prop name|type|default|description|
|---|---|---|---|---|
|name|`string`|`undefined`|Field group identifier|
|type|"checkbox"|`undefined`|Type of the field group component|
|input|`object`| `undefined` |Control functions. Is provided by `<Field />` component. |
|meta|`object`|`undefined`|Meta informations. Is provided by `<Field />` component. |

**You must pass type="checkbox" prop to the Field component for checkbox field group**

**Usage**
```javascript
import { Field } from 'react-final-form';
import { FieldGroup, FinalFormCheckBox } from '@manageiq/react-ui-components/dist/forms'

<FieldGroup label="Field group" name="checkboxGroup">
  <Field
    name="check1"
    id="check1"
    type="checkbox"
    component={FinalFormCheckBox}
    label="Checkbox"
  />
  <Field
    name="check2"
    id="check2"
    type="checkbox"
    component={FinalFormCheckBox}
    label="Checkbox"
  />
</FieldGroup>
```

####Rediobutton FieldGroup

**Radiobutton props**
|prop name|type|default|description|
|---|---|---|---|---|
|name|`string`|`undefined`|Field group identifier|
|label|`string`|`undefined`|Label next to a checkbox|
|type|"radio"|`undefined`|Type of the field group component|
|value|`any`|`undrfined`|Value of the radiobutton in form state|
|input|`object`| `undefined` | Control functions. Is provided by `<Field />` component. |
|meta|`object`|`undefined`|Meta informations. Is provided by `<Field />` component. |

**You must pass type="radio" and value prop to Field component for radio field group**

**Usage**
```javascript
import { Field } from 'react-final-form';
import { FieldGroup, FinalFormRadio } from '@manageiq/react-ui-components/dist/forms'

<FieldGroup label="Field group" name="radioGroup">
  <Field
    name="radioGroup"
    id="radio1"
    type="radio"
    component={FinalFormRadio}
    label="Option 1"
    value="First value"
  />
  <Field
    name="radioGroup"
    id="radio2"
    type="radio"
    component={FinalFormRadio}
    label="Option 2"
    value="Second value"
  />
</FieldGroup>
```


### Examples

Bellow are the most common examples for forms. FinalFormApi is very flexible and allows for creating very complex and specific forms. If there are some examples missing please check [react-final-form examples on github](https://github.com/final-form/react-final-form#examples).

#### Simple form
This will create very simple form with two inputs and no validation. The Submit button is disabled if the form has not been changed. And there is also a reset button.

```javascript
import React from 'react';
import { Form, Field } from 'react-final-form';
import { Form as PfForm, Button, Grid, Row, Col } from 'patternfly-react';
import { FinalFormField } from '@manageiq/react-ui-components/dist/forms'

const SimpleForm = () => (
  <Grid>
    <Form
      onSubmit={console.log}
      render={({ handleSubmit, pristine, form: { reset } }) => (
        <PfForm horizontal>
          <h1>Simple Form</h1>
          <Row>
            <Col xs={12}>
              <Field
                name="first-name"
                label="First name"
                placeholder="Type your name here"
                component={FinalFormField}
              />
            </Col>
            <Col xs={12}>
              <Field
                name="last-name"
                label="Last name"
                placeholder="Type your last name here"
                component={FinalFormField}
              />
            </Col>
          </Row>
          <Row>
            <Col xs={12}>
              <div>
                <Button bsStyle="primary" disabled={pristine} onClick={handleSubmit}>Submit</Button>
                <Button onClick={reset}>Reset</Button>
              </div>
            </Col>
          </Row>
        </PfForm>
      )}
    />
  </Grid>
)

```

#### Global form validation
You can use global form values validation. By adding a validation function prop to form, you can achieve Form-level validation.
Validation functions are pure functions that have the field value on input. If the field is valid, it should return `undefined`. If the Field is invalid, it should return string Error message. We can use the same example as before and add required propery to both fields and some other validation.
Writing the global validation is not very clean and is not very reusable. It should be used for specific use-cases such as comparing two or more field values (comparing passwords for example).

```javascript
import React from 'react';
import { Form, Field } from 'react-final-form';
import { Form as PfForm, Button, Grid, Row, Col } from 'patternfly-react';
import { FinalFormField } from '@manageiq/react-ui-components/dist/forms'

const SimpleForm = () => (
  <Grid>
    <Form
      onSubmit={console.log}
      validate={values => {
        const errors = {};
        if(!values['first-name'] || !values['first-name'].length === 0) {
          errors['first-name'] = 'First name is required!'
        }
        if((!values['last-name'] || !values['last-name'].length === 0) && !['Pepa', 'Mrkev', 'Lakatos'].includes(values['last-name'])) {
          errors['last-name'] = 'last name is required and must be Pepa, Mrkvev or Lakatos!'
        }
      }}
      render={({ handleSubmit, pristine, invalid, form: { reset } }) => (
        <PfForm horizontal>
          <h1>Simple Form</h1>
          <Row>
            <Col xs={12}>
              <Field
                name="first-name"
                label="First name"
                placeholder="Type your name here"
                component={FinalFormField}
              />
            </Col>
            <Col xs={12}>
              <Field
                name="last-name"
                label="Last name"
                placeholder="Type your last name here"
                component={FinalFormField}
              />
            </Col>
          </Row>
          <Row>
            <Col xs={12}>
              <div>
                <Button bsStyle="primary" disabled={pristine || invalid} onClick={handleSubmit}>Submit</Button>
                <Button onClick={reset}>Reset</Button>
              </div>
            </Col>
          </Row>
        </PfForm>
      )}
    />
  </Grid>
)

```

#### Field level validation
You can also validate each field separately. This is the prefered way of validation. Validation function has the same rules as in global validation.
Field level validation example:
```javascript
const validate = value => ['Pepa', 'Karel', 'Mojmir'].includes(value) ? undefined : 'Name must be one of: Pepa, Karel, Mojmir'

 <Field
  name="last-name"
  label="Last name"
  placeholder="Type your last name here"
  component={FinalFormField}
  validate={validate}
/>
```

#### Multiple validatotors
There are cases where you might need multiple validators on one field. You can use `composeValidators` function. Validators are run sequentually. And only the first validation error will be shown.

```javascript
import { composeValidators } from '@manageiq/react-ui-components/dist/forms';

const validate = value => ['Pepa', 'Karel', 'Mojmir'].includes(value) ? undefined : 'Name must be one of: Pepa, Karel, Mojmir'
const validateRequired = value => value && value.trim().length > 0 ? undefined : 'Name is required';

 <Field
  name="last-name"
  label="Last name"
  placeholder="Type your last name here"
  component={FinalFormField}
  validate={composeValidators(validateRequired, validate)}
/>
```

### Passing data outside of the form
If you need to access the data outside of the form component (store them to Redux for example), you can use `FormSpy` component. FormSpy `onChange` method will receive the `formState` as a default param. From there you can access all the information you might need in some other component.

```javascript
import React from 'react';
import { Form, Field, FormSpy } from 'react-final-form';

export default = ({ customOnChange }) => (
  <Form
  ...
  render={({ values }) => (
    <form>
      <Field ... />
      <FormSpy form="example" onChange={state => customOnChange(state)} />
    </form>
  )}
  ...
  >
)
```
