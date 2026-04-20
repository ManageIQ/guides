## Cypress in manageiq-ui-classic

### Setup

#### Initial Setup (One-Time)

```bash
cd manageiq-ui-classic
yarn  # Install Cypress and dependencies (run once initially, then again when packages are updated)
```

<details>

<summary>Database Requirements (One-Time Setup)</summary>

##### Database Requirements

Cypress uses the development database from `config/database.yml` and expects a clean, seeded database.

1. Configure a separate database in ManageIQ `config/database.yml` under `development`, or use your existing development database. If you use your existing database, these setup steps will completely erase it.

```yaml
development:
  # database: vmdb_development  # Your regular dev database with data
  database: vmdb_cypress        # Clean database for Cypress tests
```

2. Set up the database Cypress will use:

```bash
# From manageiq directory
bundle exec rake evm:db:reset  # Drops, creates, and migrates the current development database from config/database.yml
bundle exec rake db:seed       # Populates default data
```

3. If you switch to a different development database later, update `config/database.yml`, then run:

```bash
bin/update  # Updates dependencies and runs migrations
```

Then restart your server.

##### Resetting the Cypress Database

If you need to reset your Cypress database back to default (e.g., you added test data and want to start fresh):

```bash
# From manageiq directory, with server stopped
bundle exec rake evm:db:reset  # Drops, creates, and migrates current RAILS_ENV database (development by default)
bundle exec rake db:seed       # Populates default data
```

Then restart your server.

</details>

#### Before Running Tests

Build webpack with the CYPRESS flag (required before running tests, and whenever UI files change):

```bash
cd manageiq-ui-classic
CYPRESS=true bin/webpack
```

##### Webpack Options
- Use `CYPRESS=true bin/webpack` for a one-time build
- Use `CYPRESS=true bin/webpack --watch` for automatic rebuilds when editing UI files

**Note:** If you skip this step, Cypress will show an error and refuse to start.

### Usage

#### Environment Variables

##### Required

- `CYPRESS=true` - disables debug notifications that would prevent Cypress from accessing UI elements, development mode code reloading, and [rate limiting](https://github.com/ManageIQ/manageiq/blob/master/lib/manageiq/rack_attack.rb)

##### Optional

- `HEADED=true` - Run with visible browser (default: headless)
- `SPEC="**/reports.cy.js"` - Run specific test file (default: all tests)
- `CYPRESS_BROWSER=chromium|edge|firefox` - Run with alternative browser (default: chrome)

#### Running Tests: Self-contained

Fully automated - no other processes needed. The rake task automatically handles starting the Rails server and simulating the queue worker.

```bash
[HEADED=true] [SPEC="**/reports.cy.js"] [CYPRESS_BROWSER=chromium|edge|firefox] CYPRESS=true bundle exec rake spec:cypress
```

#### Running Tests: Manual server

Non-interactive but requires separate Rails server (and optionally Rails console with simulated queue worker for some tests).

Start Rails server in separate terminal:

```bash
CYPRESS=true bin/rails s
```

Optional: Start queue worker simulation in another terminal (needed for some tests):

```bash
bundle exec rake app:evm:simulate_queue_worker # from manageiq-ui-classic directory
# OR
bundle exec rake evm:simulate_queue_worker # from manageiq directory
```

Run tests with optional HEADED and SPEC parameters using Chrome (default):

```bash
[HEADED=true] [SPEC="**/reports.cy.js"] CYPRESS=true yarn cypress:run:chrome
```

Or use alternative browsers (chromium, edge, firefox):

```bash
[HEADED=true] [SPEC="**/reports.cy.js"] CYPRESS=true yarn cypress:run:chromium
[HEADED=true] [SPEC="**/reports.cy.js"] CYPRESS=true yarn cypress:run:edge
[HEADED=true] [SPEC="**/reports.cy.js"] CYPRESS=true yarn cypress:run:firefox
```

#### Running Tests: Interactive UI

Run tests interactively with the Cypress UI (useful for debugging).

Terminal 1 - Start webpack with --watch for live UI updates:

```bash
CYPRESS=true bin/webpack --watch
```

Terminal 2 - Start Rails server:

```bash
CYPRESS=true bin/rails s
```

Terminal 3 - Simulate queue worker (needed for some tests):

```bash
bundle exec rake app:evm:simulate_queue_worker # from manageiq-ui-classic directory
# OR
bundle exec rake evm:simulate_queue_worker # from manageiq directory
```

Terminal 4 - Open Cypress interactive UI:

```bash
CYPRESS=true yarn cypress:open
```

This opens the Cypress UI. From there:

1. Select "E2E Testing"
2. Choose your browser (Chrome recommended for development)
3. Click on a spec file to run it
4. Watch tests run in real time with:
   - Left side: test results with pass/fail status
   - Right side: live browser view of the application
   - Top bar: controls to pause, rerun, and see pass/fail counts

Note: Without `--watch`, you can run webpack and Cypress UI in the same terminal.

##### Tip

It's good practice to run all commands from the `manageiq-ui-classic` directory. While `bin/rails s` can be run from the `manageiq` directory, commands like `bin/webpack` and Cypress commands only work from `manageiq-ui-classic`. Running everything from one location helps keep organized.

<details>

<summary>Debugging Configuration</summary>

### Debugging Configuration

#### Memory and Snapshot History

The `cypress.config.js` file contains `numTestsKeptInMemory: 0` to prevent memory issues with large test files (like `menu.cy.js` which visits every page in the UI). However, this prevents viewing snapshot history when debugging.

To enable snapshot history for easier debugging:
- Comment out the line: `// numTestsKeptInMemory: 0`
- Or change to a value > 0: `numTestsKeptInMemory: 50`

Remember to reset this before committing if you're working on large test files.

</details>

### Writing Tests

<details>

<summary>Important Files</summary>

#### Important Files

Understanding these files will help you write and debug Cypress tests:

#### `cypress.config.js`
- Contains Cypress configuration settings
- Defines base URL, viewport size, video recording settings
- Controls `numTestsKeptInMemory` for debugging vs. performance

#### `cypress/support/e2e.js`
- Imports all Cypress commands and assertions
- Contains global error handling logic
- Example: Handles `uncaught:exception` errors that don't affect tests but would cause false failures in certain browsers

#### `cypress/support/assertions/`
- Contains reusable test assertion functions
- Use these to verify expected UI behavior
- Example: `cy.expect_text(element, text)` verifies element contains expected text
- Think of assertions as "test case commands" that verify conditions

#### `cypress/support/commands/`
- Contains reusable Cypress commands for common UI interactions
- Use these to navigate, click, read data, etc.
- Example: `cy.login()`, `cy.menu()`, `cy.toolbar()`
- Think of commands as "UI interaction helpers" that aren't tests themselves

Actual tests can be found in `cypress/e2e/ui/` in the [manageiq-ui-classic repository](https://github.com/ManageIQ/manageiq-ui-classic/tree/master/cypress/e2e/ui).

</details>

ManageIQ implements the following cypress extensions:

<details>

<summary>Cypress Commands (API Reference)</summary>

### Cypress Commands

#### explorer

* `cy.accordion(title)` - open an accordion panel. `title`: String for the accordion title for the accordion panel to open.
* `cy.accordionItem(name)` - click on a record in the accordion panel. `name`: String for the record to click in the accordion panel.
* `cy.selectAccordionItem(accordionPath)` - navigates the expanded accordion panel(use cy.accordion to expand an accordion panel) and then expand the nodes along the given path and click the final target item. `accordionPath`: A mixed array of strings and/or regex patterns that represent the path to the intended target node. e.g. Simple string path: `cy.selectAccordionItem(['Datastore', 'My-Domain', 'My-Namespace']);`, Path with regular expressions: `cy.selectAccordionItem([/^ManageIQ Region:/, /^Zone:/, /^Server:/]);`, Mixed path with strings and regular expressions: `cy.selectAccordionItem([/^ManageIQ Region:/, 'Zones', /^Zone:/]);`

#### gtl

* `cy.gtl_error()` - check that error message is present.
* `cy.gtlGetTable()` - returns GTL table.
* `cy.gtlGetRows(columns)` - return GTL table row data in an array. `columns`: Array of 0-based indexes of the columns to read (e.g. [1, 2, 3] will return all row data from columns 1, 2, and 3).
* `cy.gtlClickRow(columns)` - click on a row in a GTL table. `columns`: Array of `{ title: String, number: Integer }`. `title` is the string you want to find in the table to click on, `number` is the column that string is found in. (e.g. `[{title: 'Default', number: 1}, {title: 'Compute', number: 2}]` will click on a row in the GTL table with `Default` in column 1 and `Compute` in column 2. Using just `[{title: 'Default', number: 1}]` will click on the first row found in the GTL table with `Default` in column 1).

#### login

* `cy.login(user = admin, password = smartvm)` - log in to ManageIQ with the provided username and password. `user`: String for the user account to log in to, default is `admin`. `password`: String for the user account password to log in with, default is `smartvm`.

#### menu

* `cy.menu('primaryMenu', 'secondaryMenu', 'tertiaryMenu')` - navigates the side bar menu items. `primaryMenu`: String for the outer menu item on the side bar. `secondaryMenu`: String for the secondary menu when a side bar menu item is clicked. `tertiaryMenu`: String (optional) for the tertiary menu when a side bar secondary item is clicked. (e.g. `cy.menu('Overview', 'Dashboard')` will navigate to the Overview > Dashboard page while `cy.menu('Overview', 'Chargeback', 'Rates')` will navigate to the Overview > Chargeback > Rates page).
* `cy.menuItems()` - returns an Array of `{ title: String, items: Array of { title: String, href: String, items: Array of { title: String, href: String } }}` for the menu items on the side bar. `title`: String for the menu item title. `href`: String for the url to navigate to, included when the menu item has no children. `items`: Array of the same object with `title` and `href`/`items`, this is included when the menu item has children menu items.

#### miq_data_table_commands

* `cy.selectTableRowsByText({ textArray })` - selects table rows that contain any of the specified text values. Iterates through each text in the array and finds the corresponding row. If any text is not found in the table, it throws an error immediately. `textArray` is an array of text values to match against table rows. e.g. `cy.selectTableRowsByText({ textArray: ['Option 1', 'Option 2'] });`
* `cy.clickTableRowByText({ text, columnIndex })` - clicks on a table row that contains the specified text. If columnIndex is provided, it will only look for the text in that specific column. `text` is the text to find in the table row. `columnIndex` is an optional 0-based index of the column to search in. e.g. `cy.clickTableRowByText({ text: 'My Service' });`, `cy.clickTableRowByText({ text: 'Active', columnIndex: 2 });`

#### tabs

* `cy.tabs({ tabLabel })` - finds a tab element within a tablist that contains the specified label text and automatically clicks it to navigate to the tab. It requires a `tabLabel` parameter and will throw an error if none is provided. `tabLabel` is the text content of the tab to select. Returns a Cypress chainable element representing the selected tab. e.g. `cy.tabs({ tabLabel: 'Collect Logs' });`,  `cy.tabs({ tabLabel: 'Settings' }).then(() => { cy.get('input#name').should('be.visible'); });`

#### toolbar

* `cy.toolbarItems(toolbarButton)` - returns an array of objects {text: String, disabled: Boolean} for the toolbar dropdown buttons for when a toolbar button is clicked. `toolbarButton` is the string for the text of the toolbar button that you want to click on.
* `cy.toolbar(toolbarButton, toolbarOption, otherOptions)` - click on the toolbar button specified by the user. Can also then click on a specified dropdown option as well. `toolbarButton` is the string for the text of the toolbar button that you want to click on. `toolbarOption` is the string for the text of the toolbar dropdown option that you want to click on. `otherOptions` is an optional object with additional options: `matchedButtonIndex` (number, default: -1) to select a specific button when multiple buttons with the same text exist. Use -1 to automatically select the first enabled button, or use 0, 1, 2... to select a specific matched button by index. e.g. `cy.toolbar('Configuration', 'Add a new Report');` (auto-selects first enabled button), `cy.toolbar('Configuration', 'Add a new Report', { matchedButtonIndex: 0 });` (selects first matched button), `cy.toolbar('Configuration', 'Add a new Report', { matchedButtonIndex: 1 });` (selects second matched button).

#### api_commands

* `cy.interceptApi({ alias, method = 'POST', urlPattern, waitOnlyIfRequestIntercepted, responseInterceptor, triggerFn, onApiResponse })` - intercepts API calls and waits for them to complete. This command will: 1) Register an intercept(in method-alias format e.g. post-myApiAlias) for the given alias & URL pattern if not already registered, 2) Execute the trigger function that makes the API call, 3) Wait for the intercepted request to complete. `alias` is the string for a unique alias for this interception. `method` is the string for the HTTP method (default: 'POST'). `urlPattern` is the string or RegExp for the URL pattern to intercept. `waitOnlyIfRequestIntercepted` is a boolean that when set to true, the command will only wait for the response if the request was actually intercepted (useful for conditional API calls - default: false). `responseInterceptor` is an optional function that can modify the response before it's returned to the application, with options to stub responses (`req.reply()`), let requests go to origin (`req.continue()`), or modify origin responses (`req.continue((res) => res.send())`). e.g. `{ responseInterceptor: (req) => req.reply({ body: { customData: 'value' } }) }`, `{ responseInterceptor: (req) => req.reply({ fixture: 'users.json' }) }`, `{ responseInterceptor: (req) => req.continue((res) => { res.send(200, { modified: true }) }) }`,  `triggerFn` is the function that triggers the API call. e.g. `{ triggerFn: () => { cy.get('button').click(); } }`. `onApiResponse` is an optional callback function that receives the interception object after the API call completes. Use this to perform assertions on the response, extract data, or perform additional actions based on the API result. Default is a no-op function. e.g. `{ onApiResponse: (interception) => { expect(interception.response.statusCode).to.equal(200); } }`. Usage example: `cy.interceptApi({ alias: 'getUsers', method: 'GET', urlPattern: '/api/users', triggerFn: () => cy.get('#load-users').click(), responseInterceptor: (req) => req.reply({ body: { name: "stubbed value" } }), onApiResponse: (interception) => { expect(interception.response.statusCode).to.equal(200); } });`
* `cy.getInterceptedApiAliases()` - returns the intercepted API aliases stored in Cypress environment variables.
* `cy.setInterceptedApiAlias(aliasKey, aliasValue)` - sets an intercepted API alias in the Cypress environment variables. `aliasKey` is the string for the key/name of the alias to set. `aliasValue` is an optional string for the value to store for the alias (defaults to the same as the key). e.g. `cy.setInterceptedApiAlias('getUsersApi');`, `cy.setInterceptedApiAlias('getUsersApi', 'customValue');`
* `cy.resetInterceptedApiAliases()` - resets the intercepted API aliases stored in Cypress environment variables.

#### custom_logging_commands

* `cy.logAndThrowError(messageToLog, messageToThrow)` - Logs a custom error message to Cypress log and then throws an error. `messageToLog` is the message to display in the Cypress command log. `messageToThrow` is the optional error message to throw, defaults to `messageToLog`. e.g. `cy.logAndThrowError('This is the logged message', 'This is the thrown error message');`, `cy.logAndThrowError('This is the message that gets logged and thrown');`

#### dual_list_commands

* `cy.dualListAction({ actionType, optionsToSelect })` - performs actions on a dual-list component (components with two lists where items can be moved between them). `actionType` is the type of action to perform, use values from DUAL_LIST_ACTION_TYPE: 'add' (move selected items from left to right), 'remove' (move selected items from right to left), 'add-all' (move all items from left to right), or 'remove-all' (move all items from right to left). `optionsToSelect` is an array of option texts to select (required for 'add' and 'remove' actions, not needed for 'add-all' and 'remove-all'). e.g. `cy.dualListAction({ actionType: DUAL_LIST_ACTION_TYPE.ADD, optionsToSelect: ['Option 1', 'Option 2'] });`, `cy.dualListAction({ actionType: DUAL_LIST_ACTION_TYPE.REMOVE, optionsToSelect: ['Option 3'] });`, `cy.dualListAction({ actionType: DUAL_LIST_ACTION_TYPE.ADD_ALL });`, `cy.dualListAction({ actionType: DUAL_LIST_ACTION_TYPE.REMOVE_ALL });`

#### element_selectors

* `cy.getFormButtonByTypeWithText({ buttonType, buttonText })` - retrieves a form button, often found in form footers, by its name and type. `buttonText` is the name or text content of the button. `buttonType` is the HTML button type (e.g., 'button', 'submit', 'reset'). Defaults to 'button'. e.g. `cy.getFormButtonByTypeWithText({buttonText: 'Cancel'});`, `cy.getFormButtonByTypeWithText({buttonText: 'Submit', buttonType: 'submit'});`
* `cy.getFormInputFieldByIdAndType({ inputId, inputType })` - retrieves a form input field by its ID and type. `inputId` is the ID of the input field. `inputType` is the HTML input type (e.g., 'text', 'email', 'password'). Defaults to 'text'. e.g. `cy.getFormInputFieldByIdAndType({inputId: 'name'});`, `cy.getFormInputFieldByIdAndType({inputId: 'name', inputType: 'text'});`
* `cy.getFormLabelByForAttribute({ forValue })` - retrieves a form label associated with a specific input field by its 'for' attribute. `forValue` is the value of the 'for' attribute that matches the input field's ID. e.g. `cy.getFormLabelByForAttribute({forValue: 'name'});`
* `cy.getFormToggleButtonById({ toggleId })` - retrieves a form toggle button element by its ID. `toggleId` is the ID of the toggle button. e.g. `cy.getFormToggleButtonById({toggleId: 'tenant_mapping_enabled'});`
* `cy.getFormLegendByText({ legendText })` - retrieves a form legend element by its text content. Legend elements are typically used as captions for fieldset elements in forms. `legendText` is the text content of the legend element. e.g. `cy.getFormLegendByText({legendText: 'Basic Information'});`
* `cy.getFormSelectFieldById({ selectId })` - retrieves a form select field by its ID. `selectId` is the ID of the select field. e.g. `cy.getFormSelectFieldById({selectId: 'select-scan-limit'});`
* `cy.getFormTextareaById({ textareaId })` - retrieves a form textarea field by its ID. `textareaId` is the ID of the textarea field. e.g. `cy.getFormTextareaById({textareaId: 'default.auth_key'});`

#### form_elements_validation_commands

* `cy.validateFormLabels(labelConfigs)` - validates form field labels based on provided configurations. `labelConfigs` is an array of label configuration objects with properties: `forValue` (required) - the 'for' attribute value of the label, `expectedText` (optional) - the expected text content of the label. e.g. `cy.validateFormLabels([{ forValue: 'name', expectedText: 'Name' }, { forValue: 'email', expectedText: 'Email Address' }]);` or using constants: `cy.validateFormLabels([{ [LABEL_CONFIG_KEYS.FOR_VALUE]: 'name', [LABEL_CONFIG_KEYS.EXPECTED_TEXT]: 'Name' }]);`
* `cy.validateFormFields(fieldConfigs)` - validates form input fields based on provided configurations. `fieldConfigs` is an array of field configuration objects with properties: `id` (required) - the ID of the form field, `fieldType` (optional, default: 'input') - the type of field ('input', 'select', 'textarea'), `inputFieldType` (optional, default: 'text') - the type of input field ('text', 'password', 'number'), `shouldBeDisabled` (optional, default: false) - whether the field should be disabled, `expectedValue` (optional) - the expected value of the field. e.g. `cy.validateFormFields([{ id: 'name', shouldBeDisabled: true }, { id: 'role', fieldType: 'select', expectedValue: 'admin' }]);` or using constants: `cy.validateFormFields([{ [FIELD_CONFIG_KEYS.ID]: 'email', [FIELD_CONFIG_KEYS.INPUT_FIELD_TYPE]: 'email' }, { [FIELD_CONFIG_KEYS.ID]: 'name', [FIELD_CONFIG_KEYS.SHOULD_BE_DISABLED]: true }]);`
* `cy.validateFormButtons(buttonConfigs)` - validates form buttons based on provided configurations. `buttonConfigs` is an array of button configuration objects with properties: `buttonText` (required) - the text of the button, `buttonType` (optional, default: 'button') - the type of button (e.g., 'submit', 'reset'), `shouldBeDisabled` (optional, default: false) - whether the button should be disabled. e.g. `cy.validateFormButtons([{ buttonText: 'Cancel' }, { buttonText: 'Submit', buttonType: 'submit', shouldBeDisabled: true }]);` or using constants: `cy.validateFormButtons([{ [BUTTON_CONFIG_KEYS.TEXT]: 'Cancel', [BUTTON_CONFIG_KEYS.BUTTON_WRAPPER_CLASS]: 'custom-button-wrapper' }]);`

#### provider_helper_commands

* `cy.fillProviderForm(providerConfig, nameValue, hostValue)` - fills a provider form based on provider configuration. `providerConfig` is the provider configuration object. `nameValue` is the name to use for the provider. `hostValue` is the hostname to use for the provider.
* `cy.validateProviderFormFields(providerConfig, isEdit)` - validates a provider form based on provider configuration. `providerConfig` is the provider configuration object. `isEdit` is whether the form is in edit mode.
* `cy.interceptAddProviderApi()` - This command intercepts the POST request to '/api/providers' that occurs when adding a provider. For Azure Stack providers, it allows the request to reach the server (so data is created) and forces a successful response.
* `cy.providerValidation({ stubErrorResponse, errorMessage })` - performs validation with optional error response stubbing. `stubErrorResponse` is whether to stub an error response. `errorMessage` is the error message to show.
* `generateProviderTests(providerConfig)` - generates all test suites for a provider. `providerConfig` is the provider configuration object.

</details>

<details>

<summary>Cypress Assertions (API Reference)</summary>

### Cypress Assertions

* `cy.expect_explorer_title(title)` - check that the title on an explorer screen matches the provided title. `title`: String for the title.
* `cy.expect_gtl_no_records_with_text({ containsText })` - verifies that the GTL view displays a "no records" message. Checks that the specified text is visible within the GTL view container. `containsText` is the optional text to verify in the no records message (defaults to 'No records'). e.g. `cy.expect_gtl_no_records_with_text();`, `cy.expect_gtl_no_records_with_text({ containsText: 'No items found' });`
* `cy.expect_no_search_box()` - check if no searchbox is present on the screen.
* `cy.expect_rates_table(headers, rows)` - check the values in a chargeback rate table. `headers`: Array of strings representing the headers of the table. `rows`: Array of type `[String, [...String], [...String], [...String], [...String], String]` where each index of the array represents a column in the table. The arrays within the `rows` array can be any length and represent the values in each given column, e.g. an array of `[0.0, 100.0]` in the index for the `Range Start` column would verify that the column contains two range starts with values `0.0` and `100.0`.
* `cy.expect_show_list_title(title)` - check the title on a show\_list screen matches the provided title. `title`: String for the title.
* `cy.expect_search_box()` - check if searchbox is present on the screen.
* `cy.expect_text(element, text)` - check if the text in the element found by doing cy.get on the element String matches the provided text. `element`: String for the Cypress selector to get a specific element on the screen. `text`: String for the text that should be found within the selected element.
* `cy.expect_flash(flashType, containsText)` - command to validate flash messages. `flashType` is the type of flash. It is recommended to use values from `flashClassMap`.`containsText` is the optional text that the flash-message should contain. e.g. `expect_flash(flashClassMap.warning, 'cancelled');`
* `cy.expect_browser_confirm_with_text({ confirmTriggerFn, containsText, proceed })` - command to validate browser confirm alerts. `confirmTriggerFn` is the function that triggers the confirm dialog. This function **must return a Cypress.Chainable**, like `cy.get(...).click()` so that Cypress can properly wait and chain .then() afterward. `containsText` is the optional text that the confirm alert should contain. `proceed` is the flag to determine whether to proceed with the confirm (true = OK, false = Cancel). e.g. `cy.expect_browser_confirm_with_text({containsText: 'sure to proceed?', proceed: true, confirmTriggerFn: () => { return cy.get('[data-testid="delete"]').click()}});`, `cy.expect_browser_confirm_with_text({ confirmTriggerFn: () => cy.contains('deleted').click()});`
* `cy.expect_modal({ modalHeaderText, modalContentExpectedTexts, targetFooterButtonText })` - command to validate and interact with modal dialogs. Verifies the modal content and clicks a specified button in the modal footer. `modalHeaderText` is the optional text to verify in the modal header (case insensitive). `modalContentExpectedTexts` is an optional array of text strings that should be present in the modal content (case insensitive). `targetFooterButtonText` is the text of the button in the modal footer to click (required). e.g. `cy.expect_modal({ modalHeaderText: 'Confirmation', modalContentExpectedTexts: ['you want to continue?'], targetFooterButtonText: 'Confirm' });`, `cy.expect_modal({ modalContentExpectedTexts: ['cannot be undone.', 'data will be permanently deleted.'], targetFooterButtonText: 'Cancel' });`, `cy.expect_modal({ targetFooterButtonText: 'OK' });`
* `cy.expect_inline_field_errors({ containsText })` - command to validate inline field error messages. `containsText` is the text that the error message should contain (required). e.g. `cy.expect_inline_field_errors({ containsText: 'blank' });`, `cy.expect_inline_field_errors({ containsText: 'taken' });`
* `cy.expect_dual_list({ availableItemsHeaderText, selectedItemsHeaderText, availableItems, selectedItems })` - command to test dual-list components (components with two lists where items can be moved between them). Tests all aspects including item selection, moving items between lists, and search functionality. `availableItemsHeaderText` is the optional string for the heading of the available items list. `selectedItemsHeaderText` is the optional string for the heading of the selected items list. `availableItems` is an optional array of strings representing the items initially in the available items list. `selectedItems` is an optional array of strings representing the items initially in the selected items list. At least one of `availableItems` or `selectedItems` must contain items. The command automatically detects whether to test a flow starting from available items or selected items based on which list has items initially. e.g. `cy.expect_dual_list({ availableItemsHeaderText: 'Available Items', selectedItemsHeaderText: 'Selected Items', availableItems: ['Item 1', 'Item 2', 'Item 3'] });`, `cy.expect_dual_list({ availableItemsHeaderText: 'Unassigned Roles', selectedItemsHeaderText: 'Assigned Roles', selectedItems: ['Role 1', 'Role 2', 'Role 3'] });`

</details>

<details>

<summary>Test Writing Guidelines</summary>

## Test Writing Guidelines

#### 1. Database State Management

##### Resetting Test Data

Our Cypress configuration captures the database table state (rows that exist) before all tests run. You can restore this state between tests using `cy.appDbState('restore')`:

```javascript
afterEach(() => {
  cy.appDbState('restore');
});
```

What `appDbState('restore')` does:
- Removes rows created during the test - Use `afterEach` with `cy.appDbState('restore')` for tests that create new records
- Does NOT restore deleted or modified rows - If your test deletes or modifies existing rows, you must manually restore them in your test

**Examples:**
- [Tests using appDbState('restore')](https://github.com/search?q=repo%3AManageIQ%2Fmanageiq-ui-classic+appDbState%28%27restore%27%29&type=code)

##### Creating Test Data with FactoryBot

Through cypress-on-rails, you can use the Rails application's existing test factories from JavaScript using `cy.appFactories()`. Check the [existing factories](https://github.com/ManageIQ/manageiq/tree/master/spec/factories) before creating a new one - you can use them directly or create new ones based on existing ones. For more on defining and using factories, see the [FactoryBot Getting Started guide](https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md).

```javascript
// Create a single record
cy.appFactories([
  ['create', 'service_template', {name: 'My Service', generic_subtype: 'custom', prov_type: 'generic', display: true}],
]).then((results) => {
  // results[0] contains the created record with its id
  const serviceTemplate = results[0];
});

// Create related records using the first record's id
cy.appFactories([
  ['create', 'service_template', {name: 'My Service'}],
]).then((results) => {
  cy.appFactories([
    ['create', 'resource_action', {action: 'Provision', resource_id: results[0].id, resource_type: 'ServiceTemplate'}],
    ['create', 'resource_action', {action: 'Retirement', resource_id: results[0].id, resource_type: 'ServiceTemplate'}]
  ]);
});
```

**Important requirements:**
- **Factory names must match existing Ruby-side factories** - The argument after 'create' (e.g., 'service_template') must correspond to a defined FactoryBot factory in the Ruby codebase
- **All factory names must be unique** - When creating new factories for Cypress tests, ensure the factory name doesn't conflict with existing factories
- **Design factories to return the needed object** - If your Cypress test needs specific information (id, name, etc.) from a created object, structure the Ruby factory so that object is the top-level return value. You may need to flip the order of how dependent associations are created in the factory

**Best practices:**
- Put complicated logic for creating records in the factory itself (in Ruby)
- Use `cy.appFactories()` to string together simple relationships in tests

**Examples:**
- [Tests using cy.appFactories()](https://github.com/search?q=repo%3AManageIQ%2Fmanageiq-ui-classic+cy.appFactories&type=code)

**Note:** Both factories and resetting test data can be used in combination with combining/splitting tests (see "Test Structure and Granularity" section below) to simplify test setup and make feature testing more readable.

#### 2. File Structure

Organize test files to match the UI navigation structure:

```
UI Navigation: Overview > Chargeback > Rates
Test File: cypress/e2e/ui/Overview/Chargeback/rates.cy.js
```

For very large test files, split them by feature or feature category so the file names describe what each test covers:
```
cypress/e2e/ui/Overview/Chargeback/Rates/rate-list.cy.js
cypress/e2e/ui/Overview/Chargeback/Rates/rate-form.cy.js
cypress/e2e/ui/Overview/Chargeback/Rates/rate-validation.cy.js
```

#### 3. No Provider Data

We currently have no way to seed real provider data to the database. This prevents testing provider-related functionality. However, many pages can be tested without provider data.

See [issue #8859](https://github.com/ManageIQ/manageiq-ui-classic/issues/8859) for a list of pages that can be tested without provider data (Phase 2 scope).

#### 4. Create Baseline Tests

For each spec file, create baseline tests that verify:
- Page loads properly
- Default data is present and correct
- Basic UI elements are visible

**Example:** In [rates.cy.js](https://github.com/ManageIQ/manageiq-ui-classic/blob/master/cypress/e2e/ui/Overview/Chargeback/rates.cy.js), baseline tests check that default rates are in the table with correct values.

#### 5. Test All Browsers

Before creating a PR, ensure your tests pass on:
- Chrome
- Edge
- Firefox

**Note:** Run tests on all browsers using the commands in the Usage section above.

#### 6. Test Structure and Granularity

Use `describe()` for organizing related tests and `it()` for individual test cases.

These are integration tests that simulate real user workflows through the UI - they're not unit tests. You'll need to decide whether to combine operations (add/edit/delete) into workflow tests or keep them separate. There are tradeoffs between test speed, test readability, and failure reporting, so weigh the pros/cons:

**Combined workflow tests:**
- Faster, simulates real user behavior
- Actions build on each other (edit and delete can use the previously added record)
- Easier to follow when setup is complex
- Less specific failures and can become long

```javascript
it('can add, edit, and delete a rate', () => {
  // Add, edit, delete in one test
});
```

**Separate tests:**
- Clearer failure reporting, easier to maintain
- Slower and harder to follow (setup often in separate beforeEach blocks)

```javascript
it('can add a rate', () => { /* ... */ });
it('can edit a rate', () => { /* ... */ });
it('can delete a rate', () => { /* ... */ });
```

**Guidelines:** Start with workflow tests for happy paths, use separate tests for edge cases and validations.

</details>