### GTL

GTL stands for Grid, Table, List.

GTL are backed by the [reporting](reports_charts.md) subsystem.

Each GTL screen is fed by report resuts through JSON endpoint `report_data`.

Data comes throught the `get_view` method in `ApplicationController`. That in
turn loads the appropriate report from the YAML definition.

Displaying is handled by an Angular component from [ui-components](https://github.com/ManageIQ/ui-components) repository.
