### GTL

GTL stands for Grid, Table, List.

GTL are backed by the [reporting](reports_charts.md) subsystem.

Each GTL screen is fed by report resuts through the `get_view` method in
`ApplicationController`. That in turn load the appropriate report from the
report definition in YAML.
