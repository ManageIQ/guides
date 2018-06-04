### Register react component
In ManageIQ project there is a way of sharing components, getting their state and control their flow by something which is called ManageIQ component.

This registry and usage consists of three steps, define blueprint that holds the react component with its props. Then you will define it inside shared components (use blueprint created in step 1). And when someone decides to use such component he will call function newInstance with custom props and element to which such component is bound to.

This way using such component is abstract for user, he doesn't know if such component was written in pure JS, React, Angular or whatever.

#### 1. Define react component
This is your first step of creating shared abstract component. You may use our custom function which fits react, should you choose angular, Vue.js or whatever you'll have to write your own funcion.

When using react blueprint function, just wrap your component (or HTML) with `addReact` function and as argument use callback which will be called with props. These props will be passed when new isntance of this component is created.

```JSX
import React from 'react';
import addReact from 'helpers';
import { YourComponent } from 'your-components/custom-component';

addReact('YourComponentName', YourComponent);
```

#### 2. New instance
When you want to create new instance of recently created component just call `newInstance` function with these arguments
* name - name of the component you wish to use.
* element - DOM element where this new instance of component should be rendered.
* props - object with props that will be mapped to your components (used when creating blueprint)

Props are optional, if you do not pass props object the component factory will look for data attribute of DOM element.
```JS
import { componentFactory } from 'helpers';

componentFactory('YourComponentName', '#selector');
```

There is helper method in ManageIQ, which helps you do this automatically by calling `react` in .haml file. This will 
result in div element with generic ID and it places component defined in step 1. over it.

```haml
= react 'YourComponentName', {:pro => 'ps'}
```

### Shared component API
Abstract shared components has API controlling active components, this way you can define and create new component, later you can access to all active components on screen and use its shared interface to interact with it.

#### Define
When you want to define new component to be used by someone call define function with name of such component and its blueprint.
```JS
import define from 'registry';

define('YourComponentName', componentBlueprint);
```

#### Get definition
To fetch definition of component you created you can call specific function. You will get name of such component and its blueprint. With such blueprint you can call functions to update, create or remove it.
```JS
import getDefinition from 'registry';

getDefinition('YourComponentName');
```

#### New instance
To create new instance and mount it to DOM element call function `newInstance`. This function not only creates new instance it also gives you object over which you can update its pros, update it or destroy it from component's drawer. Inside this object you will also find comeponent's instance ID and should the component choose its interact property for side channel communication.

When creating new instance you have option to pass multiple parameters:
* name - component's name under which component was defined
* props - default props for the component
* element - DOM element under which this component should be rendered (optional)
```JS
import newInstance from 'registry';

newInstance('YourComponentName', {}, element);
```

#### export instance
To receive component's instance from registery you can call function `getInstance`. You will get full information about this instance, ways to interact with it and s name and ID.
```JS
import getInstance from 'registry';

getInstance('YourComponentName', componentID);
```

#### Is defined
Check if component with some name is defined in drawer. Great for checking if component's name is available.
```JS
import isDefined from 'registry';

isDefined('YourComponentName');
```

### Component instance API
When you create new instance or search for instance of component you will receive object over which you can interact with this instance and observe its properties.

#### ID
Instance's ID under which its created.

#### interact
Should the component chooses it can supply object over which its possible side channel communication.

#### props
Instance's props object containing public properties.

#### update
This function helps you to update component's public props. You can add new prop or update existing prop.

#### destroy
To destroy instance and remove it from DOM (no point of return) simply call this function.

### Import mapping
When using this API in older code without option to import some functions were made available over `window.ManageIQ` object.

* `addReact` -> `ManageIQ.component.addReact`
* `define` -> `ManageIQ.component.define`
* `getInstance` -> `ManageIQ.component.getInstance`
* `isDefined` -> `ManageIQ.component.isDefined`
* `newInstance` -> `ManageIQ.component.newInstance`
* `reactBlueprint` -> `ManageIQ.component.reactBlueprint`