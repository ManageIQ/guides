## Logging

ManageIQ uses the standard Ruby [Logger](https://ruby-doc.org/stdlib-2.6.6/libdoc/logger/rdoc/Logger.html)
interface, with a custom formatter that is mostly just minor changes from the
default formatter.  Additionally, we use a logger abstraction library, called
[manageiq-loggers](github.com/ManageIQ/manageiq-loggers) in order to support
multiple log targets and formats.

An example log message looks like:

```text
[----] I, [2020-01-01T12:34:56.789012 #12345:6789abcdef01]  INFO -- : MIQ(Class#method) Example message
```

where:

- `[----]` is a placeholder for future use
- `I` is the single character form of the log level (e.g. `I` == `INFO`)
- `2020-01-01T12:34:56.789012` is the timestamp of the message in ISO8601 format
- `12345` is the process ID (PID)
- `6789abcdef01` is the Ruby thread ID (TID) in hexadecimal
- `INFO` is the log level (can also be `DEBUG`, `WARN`, `ERROR`, `FATAL`)
- `MIQ(Class#method)` is an optional location in the code where the message was logged
- `Example message` is the logged message

### Container log format

In container deployments, ManageIQ also broadcasts logs to STDOUT in structured
JSON format, so that it can be consumed by a cluster-level log aggregator.  For,
example OpenShift has a feature called cluster logging, which consumes STDOUT and
feeds those lines to ElasticSearch as part of an EFK stack (ElasticSearch /
Fluentd / Kibana). However, because it is simple JSON, the output could be
consumed by any log aggregator, such as Splunk, if it were so configured.

An example log message looks like the following:

```json
{
  "@timestamp":"2020-01-01T12:34:56.789012",
  "pid":12345,
  "tid":"6789abcdef01",
  "level":"info",
  "message":"MIQ(Class#method) Example message"
}
```

NOTE: The JSON is broken apart here for demonstration, but in STDOUT will appear
as a single line.

### Development

In development, a number of log objects are available, with `$log` being the
primary log object.  There are a number of separate log objects created for
various purposes, particularly for provider clients.  The Rails logger is also
available via `$rails_log` (or the standard `Rails.logger`). See
[lib/vmdb/loggers.rb](https://github.com/ManageIQ/manageiq/blob/master/lib/vmdb/loggers.rb)
for the complete list of loggers.

Additionally, if the [`Vmdb::Logging`](https://github.com/ManageIQ/manageiq/blob/master/lib/vmdb/logging.rb)
module is mixed into a class, then the _log method is available.  This method will
automatically prefix the code location to the message, and so is the most preferred
way to do logging.
