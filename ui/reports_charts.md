### Reports and Charts

Reports are an important part of ManageIQ. Reports feed data not for the 'Reports' section of UI but also:
 * Charts,
 * Widgets and
 * GTL screens.

Reports definitions are stored under `product/reports/` and chart definitions are
stored under `product/charts/`.

#### Reports

This is an example report w/o a chart:

```
--- 
dims: 
created_on: 2008-08-11 22:29:55.101908 Z
title: "Registered VMs by Free Space"
conditions: !ruby/object:MiqExpression 
  exp: 
    IS NOT NULL: 
      field: Vm.hardware-size_on_disk
updated_on: 2008-08-11 22:36:07.331335 Z
order: Ascending
graph: 
menu_name: "Registered VMs by Free Space"
rpt_group: Custom
priority: 231
col_order: 
- name
- host.name
- hardware.disk_capacity
- hardware.disk_free_space
- v_pct_free_disk_space
- v_pct_used_disk_space
timeline: 
id: 81
file_mtime: 
categories: 
rpt_type: Custom
filename: 
include: 
  hardware: 
    columns: 
    - disk_capacity
    - disk_free_space
  host: 
    columns: 
    - name
db: Vm
cols: 
- name
- v_pct_free_disk_space
- v_pct_used_disk_space
template_type: report
group: 
sortby: 
- hardware.disk_free_space
headers: 
- VM Name
- Host Name
- Total Disk
- Free Disk
- Pct Free Disk
- Pct Used Disk
```

Some important attributes:
 * db: the underlying table,
 * include: joined tables (meaning JOIN as in SQL),
 * sortby: columns to use as sort criteria,
 * cols: columns from the table given in db,
 * col\_order: order of all columns,
 * headers: headers of columns (needs to match col\_order),
 * col\_formats: formatting rules for the columns (needs to match col\_order),
 * conditions: selection rules,
 * group: uses to do GROUP BY.

Reports can be created manually or through the Report editor in the UI (user reports). A way to create a new report for the UI might be playing with the editor, then inspecting the resulting report and
creating the YAML definition.

#### Charts

Data-wise there are 2 types of charts:
 * charts that visualize count number of discrete values in a report,
 * charts that visualize exact values from a report.

Charts are created in the Report editor together with reports.

### Dashboard Widgets

Dashboard widgets under cloud intelligence are populated by data from ReportResults that are generated from Reports. That includes the charts.

Dashboard definitions live in `product/dashboard/dashboards/` and widget definitions under `product/dashboard/widgets`.

