### Redux
In UI-classic we enabled [redux](https://github.com/reactjs/redux) to work with state of application so we can easilly
 detect from where which action comes and to see the flow of data.

#### Writing reducers
To change state of application you will need to write reducer which is basically simple function which takes current 
state and action. Result of such reducer is somehow changed state based on action.

Action consists of
 * Type of action - string which says what action has been triggered
 * Payload - usually JS object with some data, which will be applied to state

##### Simple reducer example
We are using redux in slightly different way, so we can control which reducer is active at given time. To create new
reducer first you have to create it and register it into redux.

1. Breaking reducers into simple functions, might be a bit confusing because it doesn't use switches as any redux example
however it's easier to test and maintain.

```javascript 1.8
/* 
 * These two functions are required for correct registering of reducer into our redux.
 * Please change path relative to your pack and from where you are registering reducers.
 */
import { addReducer, applyReducerHash } from '../miq-redux/reducer';

// Constants of action types
const FIRST_ACTION = 'first_action';
const SECOND_ACTION = 'second_action';

/* 
 * Simple reducer function
 * It takes state and action as parameters and changes state based on action.payload
 * Notice the rest operator which allows changing of state with action payload.
 */
function firstReducerFn(state, action) {
  return {...state, someValue: action.payload};
}

/*
 * A bit more complex reducer, which takes two values off of action payload and applies them into state.
 * You can notice, that we used different approach and used Object.assign for changing state.
 */
function secondReducerFn(state, action) {
  const someObject = {
    differentValue: action.payload.oneValue,
    anotherValue: action.payload.secondValue
  };
  return Object.assign({}, state, someObject);
}

// This is how we say that which action type maps to which function.
const mappedReducers = {
  [FIRST_ACTION]: firstReducerFn,
  [SECOND_ACTION]: secondReducerFN
};

/*
 * This is probably the most important and also most confusing part of how to register reducer.
 * Function addReducer helps us to add newly created reducer into our bulk of reducers which were created before.
 * Function applyReducerHash helps us to bind state and action for each reducer which we mapped before.
 */
const unbind = addReducer(
  (state, action) => applyReducerHash(mappedReducers, state, action)
)

/* Notice that we created unbind constant which is taking whatever is returned from addReducer.
 * This little guy is just callback to our Set. Calling it will remove our reducers from all reducers, this way you can
 * control when to remove such reducers. But don't worry it's not needed, just nice. 
 */
```

2. Using switch as described in many redux examples. It does the same thing as example before, but it doesn't brake
reducers into simple functions and it uses switches, which someone might like and someone not.
```javascript 1.8
/* 
 * This function is required for correct registering of reducer into our redux.
 * Please change path relative to your pack and from where you are registering reducers.
 */
import { addReducer } from '../miq-redux/reducer';

// Constants of action types
const FIRST_ACTION = 'first_action';
const SECOND_ACTION = 'second_action';

/*
 * Simple redux reducer with two branches.
 */
function someApp(state, action) {
  switch (action.type) {
      case FIRST_ACTION:
        return {...state, someValue: action.payload};
      case SECOND_ACTION:
        const someObject = {
          differentValue: action.payload.oneValue,
          anotherValue: action.payload.secondValue
        };
      return Object.assign({}, state, someObject);
  }
}

/*
 * This is probably the most important and also most confusing part of how to register reducer.
 * Function addReducer helps us to add newly created reducer into our bulk of reducers which were created before.
 */
const unbind = addReducer(someApp);

/* Notice that we created unbind constant which is taking whatever is returned from addReducer.
 * This little guy is just callback to our Set. Calling it will remove our reducers from all reducers, this way you can
 * control when to remove such reducers. But don't worry it's not needed, just nice. 
 */
```

### Folder structure
Note in mind, that this is example on how to write global reducers. If you are writing reducer which is specific to your
pack, please replace `app/javascipt/reducers/reducer-example` with `app/javascript/your-pack/reducers/` this way we can 
abstract same logical things.

**`app/javascipt/reducers/reducer-example/actions.js`**

Here you will write functions which reacts to actions with payload and change state.
```javascript 1.8
export function firstReducerFn(state, action) {
  // do something with state
  return state;
}
export function secondReducerFn(state, action) {
  // do something completely different with state
  return state;
}
```
**`app/javascipt/reducers/reducer-example/types.js`**

Here you will write constants which will be used for dispatching and for mapping simple functions to action types
```javascript 1.8
export const FIRST_ACTION = 'firstExampleAction';
export const SECOND_ACTION = 'secondExampleAction';
//... more actions
export const ANOTHER_ACTION = 'someOtherAction';
export const ONE_MORE_ACTION = 'absolutelyDifferentAction';
```
**`app/javascipt/reducers/reducer-example/index.js`**

Here you will glue together actions and types, plus you will export all types so they can be dispatched later on.
Please export any reducer's type which can be used later on, so anybody can use your constant and we don't have to look
for some magic constant strings.
```javascript 1.8
import { firstReducerFn, secondReducerFn } from './actions';
import { FIRST_ACTION, SECOND_ACTION, ANOTHER_ACTION, ONE_MORE_ACTION } from './types';
import { addReducer, applyReducerHash } from '../miq-redux/reducer';

export { FIRST_ACTION, SECOND_ACTION, ANOTHER_ACTION, ONE_MORE_ACTION };

const typesToActions = {
  [FIRST_ACTION]: firstReducerFn,
  [SECOND_ACTION]: secondReducerFn,
  //..
}

addReducer(
  (state, action) => applyReducerHash(typesToActions, state, action)
)
```

#### Dispatching action
Dispatching actions is basically how redux changes it's state. 

To dispatch single action for any reducer you have to call publicly available redux store
```javascript 1.8
import { FIRST_ACTION } from './reducers';
ManageIq.redux.store.dispatch({type: FIRST_ACTION, payload: {someValue: {}}});
```