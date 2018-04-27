### Report data API
Report data is component which is reponsible for showing data inside Grid, Tile and List (refered to as GTL). This component shows a lot of data so it comes with API along side of it. This API is for working with GTL and both changing its state and getting data out of it.

#### Sending data
To initiate any action you just simply call specific function called `sendDataWithRx` which is hooked to `Rx.js`'s Subject and forwards these messeges to corresponding controller.

You have to specify 3 attributes when comunicating with report data API
1) controller - `reportDataController`, constant and should not be changed
2) action - what action should be initiated
3) data - if action requires some data pass them via this attribute

Example of how to send data to GTL:
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'SOME_ACTION_NAME',
    data: []
})
```
Notice that data is always array even if you are sending single value always pass it as array.

Some actions will store data in `ManageIQ.qe.gtl.result`, it's either direct result (string, number) or object which contains item or items, based on action.

#### Actions

##### `select_item`
Action which selects item based on its id. Data should be array with first attribut ID of item and second `true|false` to select|deselect item.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'select_item',
    data: [1, true]
})
```

##### `click_item`
Action to click on item and take you to detail page of such item. Data should be array with one attribute ID.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'click_item',
    data: [1]
})
```

##### `select_all`
Action to select all items on screen. Data should be array with one attribute `true|false` to select|deselect all items.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'select_all',
    data: [true]
})
```

##### `go_to_page`
To navigate to specific page call this action. Data should be array with one attribute, page number.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'go_to_page',
    data: [5]
})
```

##### `last_page`
This action will lead you to last page, no need to send any data.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'last_page'
})
```

##### `first_page`
Action which is oposite of `last_page`, it will take you to first page. Again no data needed.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'first_page'
})
```

##### `previous_page`
To navigate to previous page call action `previous_page`, no data required.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'previous_page'
})
```

##### `next_page`
This action is oposite of `previous_page` and it will take you to next page. No data needed.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'next_page'
})
```

##### `get_current_page`
This action will store into `ManageIQ.qe.gtl.result` page number on which you currently are. No data needed.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'get_current_page'
})
```

##### `get_pages_amount`
Action which stores into `ManageIQ.qe.gtl.result` number of pages, no data needed.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'get_pages_amount'
})
```

##### `get_items_per_page`
This actions stores into `ManageIQ.qe.gtl.result` number of items per page, no data needed.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'get_items_per_page'
})
```

##### `set_items_per_page`
To change how many items should be visible per page call this function. Data should be number of items per page, please use `5`, `10`, `20`, `50`, `100` or `1000` as items per page.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'set_items_per_page',
    data: [10]
})
```

##### `set_sorting`
To change sorting order call this function as object it requires array with object containing column id and if isAscending.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'set_sorting',
    data: [{sortBy: 2, isAscending: true}]
})
```

##### `get_sorting`
To retrieve object how data are sorted call this action and it will store into `ManageIQ.qe.gtl.result` desired information, no data needed.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'get_sorting'
})
```

##### `get_all_items`
Action which will store into `ManageIQ.qe.gtl.result` all items on screen, no data needed.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'get_all_items'
})
```

##### `get_item`
This action is for retrieving one item into `ManageIQ.qe.gtl.result`, data should be array with one item which is either ID (number) or name (string). If item is not present on screen no data will be returned.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'get_item',
    data: ['aaaop3322']
})
```

##### `query`
For some really sophisticated filtering over items call this action which will then stores the results into `ManageIQ.qe.gtl.result`. This action can take multiple data over which to query and it can then return multiple items which are found.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'query',
    data: [{name: 'cfmear01', datastore: 'some-data-store'}]
})
```

##### `is_displayed`
This action will store into `ManageIQ.qe.gtl.result` if item is visible. Data should be id or name of item.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'is_displayed',
    data: [2]
})
```

##### `pagination_range`
This action will store into `ManageIQ.qe.gtl.result` object which will contain information about pagination - `total`, `start`, `end`, `pageCount`. No data required.
```javascript
sendDataWithRx({
    controller: 'reportDataController',
    action: 'pagination_range'
})
```

#### Item result
If you want to get item from this API, you will receive object with multiple items
* click - function to click on item
* is_selected - function to retrieve if item is selected
* select - select item
* unselect - unselect item
* item - object with item's information
  * cells - values of each cell
  * id - item's id
  * long_id - item's long_id
  * quad - quad information
    * topLeft - `fileicon`|`fonticon`|`tooltip`|`text`|`background`|`color`
    * topRight - `fileicon`|`fonticon`|`tooltip`|`text`|`background`|`color`
    * bottomLeft - `fileicon`|`fonticon`|`tooltip`|`text`|`background`|`color`
    * bottomRight - `fileicon`|`fonticon`|`tooltip`|`text`|`background`|`color`
  * gtlType - `grid`|`tile`|`list`