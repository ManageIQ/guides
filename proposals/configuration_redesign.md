# Configuration Redesign

As a User, I want to be able to set configuration settings for multiple servers at once at any scoping level (Region, Zone, etc).

As a Developer, I want to be able to access any server's configuration from code in a performant way.

## Requirements

* Scopes: template, enterprise, region, zone, server, development
* Get/set configurations for any server at any level
* Support multiple configuration files (vmdb, event_handling, etc.)

### UI
* Currently gets the configurations, work with it as a hash, and is able to save or reset.
* Remove advanced settings as YAML modifications directly and replace (tree?)

### Add/Removes/Updates by dev
* New keys can be added to the template by dev and should just be included.
* Deletes in templates should possibly cleanup deltas from other scopes (maybe not for hidden keys)(may force a data migration)
* Key moves must be handled with a data migration
* Template value updates may require notification if the user has changed their value also (do or do not force our key value changes)

### Other
* Remove primordial settings (settings needed before database access, like log settings) from vmdb.yml and create a new .yml file.
* Support typing of values (String vs. Integer, password fields, etc.)
* Provide a way to revert back to template/default
* Migrate changes from existing configurations table.
* Special cases: database.yml, other primordial stuff like log settings

## Implementation

configurations table will store deltas from the template.

| Column     | Type      | Comment |
| ---------- | --------- | ------- |
| file       | string    | vmdb, event_handling, etc. (pick a better name) |
| key        | string    | a URI like string representing the nesting. e.g. /workers/worker_base/ui_worker/count |
| value      | text      | text serializes allowing storing of type as well as complex values |
| scope      | string    | enterprise, region, zone, server, development (template scope is not stored in the database) |
| created_at | timestamp | |
| updated_at | timestamp | |

`Vmdb::Config` class, when loading a particular configuration will load the template from the file system, then apply delta rows in scope order.  All region deltas, then all zone deltas, etc.  Final result is cached as the singleton.

- When a user makes a change, we add a delta row.
- When a user chooses reset to default, we remove the delta row.
- When a user makes a change on an existing delta, even if the change matches the current default from the template, keep the delta in the table so their changes will remain even if our default changes.  This allows consciously making the choice of a value, versus making the choice to use the default.

When a change is saved to the configuration, invalidate the local cache, and notify
  all servers via the queue that they should invalidate their caches as well.

The api should provide singleton methods to access the cached copy at different scopes for each file
```ruby
Vmdb::Config["vmdb"] # default is my_server level
Vmdb::Config["vmdb", :region]
```

Callers currently treat the config like a set of nested hashes, so we may want expose the same interface.  fetch_path (an evm Hash extension) is used extensively in caller code as well.

## UI / UX

Currently we have specialized screens for modifying certain configuration options.  Beyond that we have the Advanced Settings page which allows the user to modify the config YAML file directly.  However, this is problematic for a number of reasons, both with usability and data integrity.

One possible solution in the new redesign is to present the data as an editable grid or a tree structure.

### Grid
- Each row would show each individual value, and afterward could be a text box and/or a "reset to default" button
- The key, default value and current value would no be modifiable.

| Key | Default Value | Current Value | New Value |
| --- | ------------- | ------------- | --------- |
| /performance/history/initial_capture_days | 0 | `<default>` | `[_____] (Reset to Default)`
| /performance/history/keep_daily_performances | 6.months | 6.months | `[_____] (Reset to Default)`
| /performance/history/keep_hourly_performances | 6.months | 3.months | `[_____] (Reset to Default)`
| /performance/history/keep_realtime_performances | 4.hours | `<default>` | `[_____] (Reset to Default)`

### Tree
- Present each value in a tree structure, at the end of which is a text box and/or a "reset to default" button

```
- performance
  - history
    - initial_capture_days
      - Default Value: "0", Current Value: `<default>`  New Value: `[_____] (Reset to Default)`
    - keep_daily_performances
      - Default Value: "6.months", Current Value: "6.months"  New Value: `[_____] (Reset to Default)`
    - keep_hourly_performances
      - Default Value: "6.months", Current Value: "3.months"  New Value: `[_____] (Reset to Default)`
    - keep_realtime_performances
      - Default Value: "4.hours", Current Value: `<default>`  New Value: `[_____] (Reset to Default)`
```
