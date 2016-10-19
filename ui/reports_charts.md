### Reports and Charts

Reports are an important part of ManageIQ. Reports feed data not for the 'Reports' section of UI but also:
 * Charts,
 * Widgets and
 * GTL screens.

Reports definitions are stored under `product/reports/`, chars definitions are
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
 * col\_order: order of all solumns,
 * headers: headers of columns (needs to match col\_order),
 * col\_formats: formating rules for the columns (needs to match col\_order),
 * conditions: selection rules,
 * group: uses to do GROUP BY.

Reports can be created by hand or through the Report editor in the UI (user reports). In that
case such report can be dumped and the definition file can be created and
included with the product.

#### Charts

Data-wise there are 2 types of chars:
 * charts that visualise count number of discrete values in a report,
 * charts that visualise exact values from a report.

Charts are created in the Report editor together with reports.

### Dashboard Widgets

Dashboard widgets under cloud inteligence are fed by data from ReportResults that are generated from Reports including charts.

Dashboard definitions live in `product/dashboard/dashboards/` and widget definitions under `product/dashboard/widgets`.

